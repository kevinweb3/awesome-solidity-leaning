// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../../openzeppelin/token/ERC20/ERC20.sol";
import "../../openzeppelin/access/Ownable.sol";
import "../../openzeppelin/utils/cryptography/ECDSA.sol";

/**
 * @dev 数字签名一般有两种常见的重放攻击：
 * 1. 普通重放：将本该使用一次的签名多次使用。NBA官方发布的《The Association》系列 NFT 因为这类攻击被免费铸造了上万枚。
 * 2. 跨链重放：将本该在一条链上使用的签名，在另一条链上重复使用。做市商 Wintermute 因为跨链重放攻击被盗2000万枚 $OP。
 */

// 权限管理错误例子
contract SigReplay is ERC20 {
    address public signer;

    // 构造函数：初始化代币名称和代号
    constructor() ERC20("SigReplay", "Replay") {
        signer = msg.sender;
    }

    /**
     * 有签名重访漏洞的铸造函数
     * to: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
     * amount: 1000
     * 签名： 0x5a4f1ad4d8bd6b5582e658087633230d9810a0b7b8afa791e3f94cc38947f6cb1069519caf5bba7b975df29cbfdb4ada355027589a989435bf88e825841452f61b
     */
    function badMint(address to, uint amount, bytes memory signature) public {
        bytes32 _msgHash = toEthSignedMessageHash(getMessageHash(to, amount));
        require(verify(_msgHash, signature), "Invalid Signer!");
        _mint(to, amount);
    }

    /**
     * 将to地址（address类型）和amount（uint256类型）拼成消息msgHash
     * to: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
     * amount: 1000
     * 对应的消息msgHash: 0xb4a4ba10fbd6886a312ec31c54137f5714ddc0e93274da8746a36d2fa96768be
     */
    function getMessageHash(
        address to,
        uint256 amount
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(to, amount));
    }

    /**
     * @dev 获得以太坊签名消息
     * `hash`：消息哈希
     * 遵从以太坊签名标准：https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
     * 以及`EIP191`:https://eips.ethereum.org/EIPS/eip-191`
     * 添加"\x19Ethereum Signed Message:\n32"字段，防止签名的是可执行交易。
     */
    function toEthSignedMessageHash(
        bytes32 hash
    ) public pure returns (bytes32) {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        return
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
            );
    }

    // ECDSA验证
    function verify(
        bytes32 _msgHash,
        bytes memory _signature
    ) public view returns (bool) {
        return ECDSA.recover(_msgHash, _signature) == signer;
    }

    mapping(address => bool) public mintedAddress; // 记录已经mint的地址

    function goodMint(address to, uint amount, bytes memory signature) public {
        bytes32 _msgHash = toEthSignedMessageHash(getMessageHash(to, amount));
        require(verify(_msgHash, signature), "Invalid Signer!");
        // 检查该地址是否mint过
        require(!mintedAddress[to], "Already minted");
        // 记录mint过的地址
        mintedAddress[to] = true;
        _mint(to, amount);
    }

    uint nonce;

    function nonceMint(address to, uint amount, bytes memory signature) public {
        bytes32 _msgHash = toEthSignedMessageHash(
            keccak256(abi.encodePacked(to, amount, nonce, block.chainid))
        );
        require(verify(_msgHash, signature), "Invalid Signer!");
        _mint(to, amount);
        nonce++;
    }
}

/**
 * @dev 签名重放攻击主要有两种预防办法：
 * 1、将使用过的签名记录下来，比如记录下已经铸造代币的地址 `mintedAddress`，防止签名反复使用：
 * 2、将 `nonce` （数值随每次交易递增）和 `chainid` （链ID）包含在签名消息中，这样可以防止普通重放和跨链重放攻击：
 */

 // 第一种预防办法
  mapping(address => bool) public mintedAddress;   // 记录已经mint的地址
    
  function goodMint(address to, uint amount, bytes memory signature) public {
    bytes32 _msgHash = toEthSignedMessageHash(getMessageHash(to, amount));
    require(verify(_msgHash, signature), "Invalid Signer!");
    // 检查该地址是否mint过
    require(!mintedAddress[to], "Already minted");
    // 记录mint过的地址
    mintedAddress[to] = true;
    _mint(to, amount);
  }

 // 第二种预防办法
 uint nonce;

    function nonceMint(address to, uint amount, bytes memory signature) public {
        bytes32 _msgHash = toEthSignedMessageHash(keccak256(abi.encodePacked(to, amount, nonce, block.chainid)));
        require(verify(_msgHash, signature), "Invalid Signer!");
        _mint(to, amount);
        nonce++;
    }

