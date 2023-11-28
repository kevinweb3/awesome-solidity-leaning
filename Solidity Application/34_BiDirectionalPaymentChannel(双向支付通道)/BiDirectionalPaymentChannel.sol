// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
1. Alice和Bob建立了一个多签名钱包
2. 预计算支付通道地址
3.Alice和Bob交换初始余额的签名
4. Alice和Bob创建了一个可以部署支付通道的事务

多重签名钱包

更新通道平衡
  1. 重复步骤1 - 3从打开一个通道
  2. 从多重签名钱包创建一个交易，将
  -删除会部署旧支付通道的交易
  -然后创建一个交易，该交易可以使用新的平衡

当Alice和Bob就最终余额达成一致时关闭通道
  1. 从多重签名钱包创建一个交易，将
  ——向Alice和Bob支付款项
  ——然后删除创建支付通道的交易

当Alice和Bob不能就最终余额达成一致时关闭通道
  1. 从多重签名部署支付通道
  2. 调用challengeExit()来启动关闭通道的过程
  3.一旦通道过期，Alice和Bob可以提取资金
*/

import "../../OpenZeppelin/utils/cryptography/ECDSA.sol";

contract BiDirectionalPaymentChannel {
    using ECDSA for bytes32;

    event ChallengeExit(address indexed sender, uint nonce);
    event Withdraw(address indexed to, uint amount);

    address payable[2] public users;
    mapping(address => bool) public isUser;

    mapping(address => uint) public balances;

    uint public challengePeriod;
    uint public expiresAt;
    uint public nonce;

    modifier checkBalances(uint[2] memory _balances) {
        require(
            address(this).balance >= _balances[0] + _balances[1],
            "balance of contract must be >= to the total balance of users"
        );
        _;
    }

    // NOTE: deposit from multi-sig wallet
    constructor(
        address payable[2] memory _users,
        uint[2] memory _balances,
        uint _expiresAt,
        uint _challengePeriod
    ) payable checkBalances(_balances) {
        require(_expiresAt > block.timestamp, "Expiration must be > now");
        require(_challengePeriod > 0, "Challenge period must be > 0");

        for (uint i = 0; i < _users.length; i++) {
            address payable user = _users[i];

            require(!isUser[user], "user must be unique");
            users[i] = user;
            isUser[user] = true;

            balances[user] = _balances[i];
        }

        expiresAt = _expiresAt;
        challengePeriod = _challengePeriod;
    }

    function verify(
        bytes[2] memory _signatures,
        address _contract,
        address[2] memory _signers,
        uint[2] memory _balances,
        uint _nonce
    ) public pure returns (bool) {
        for (uint i = 0; i < _signatures.length; i++) {
            /*
            NOTE: sign with address of this contract to protect
                  agains replay attack on other contracts
            */
            bool valid = _signers[i] ==
                keccak256(abi.encodePacked(_contract, _balances, _nonce))
                    .toEthSignedMessageHash()
                    .recover(_signatures[i]);

            if (!valid) {
                return false;
            }
        }

        return true;
    }

    modifier checkSignatures(
        bytes[2] memory _signatures,
        uint[2] memory _balances,
        uint _nonce
    ) {
        // Note: copy storage array to memory
        address[2] memory signers;
        for (uint i = 0; i < users.length; i++) {
            signers[i] = users[i];
        }

        require(
            verify(_signatures, address(this), signers, _balances, _nonce),
            "Invalid signature"
        );

        _;
    }

    modifier onlyUser() {
        require(isUser[msg.sender], "Not user");
        _;
    }

    function challengeExit(
        uint[2] memory _balances,
        uint _nonce,
        bytes[2] memory _signatures
    )
        public
        onlyUser
        checkSignatures(_signatures, _balances, _nonce)
        checkBalances(_balances)
    {
        require(block.timestamp < expiresAt, "Expired challenge period");
        require(_nonce > nonce, "Nonce must be greater than the current nonce");

        for (uint i = 0; i < _balances.length; i++) {
            balances[users[i]] = _balances[i];
        }

        nonce = _nonce;
        expiresAt = block.timestamp + challengePeriod;

        emit ChallengeExit(msg.sender, nonce);
    }

    function withdraw() public onlyUser {
        require(
            block.timestamp >= expiresAt,
            "Challenge period has not expired yet"
        );

        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");

        emit Withdraw(msg.sender, amount);
    }
}
