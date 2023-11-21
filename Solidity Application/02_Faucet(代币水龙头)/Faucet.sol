// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// 代币水龙头

import "./IERC20.sol";

/**
 * 1、在合约部署的时候实现合约名称和符号初始化
 * 2、实现了5个函数（代币转账、代币授权、代币授权转账、铸造代币、销毁代币）
 */
contract ERC20 is IERC20 {
    mapping(address => uint256) public override balanceOf;

    mapping(address => mapping(address => uint256)) public override allowance;

    uint256 public override totalSupply;

    string public name;

    string public symbol;

    uint8 public decimals = 18;

    // @dev 在合约部署的时候实现合约名称和符号
    constructor(string memory name_, string memory symbol_) {
        name = name_;
        symbol = symbol_;
    }

    // @dev 实现`transfer`函数，代币转账逻辑
    function transfer(
        address recipient,
        uint256 amount
    ) external override returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Trancefer(msg.sender, recipient, amount);
        return true;
    }

    // @dev 实现 `approve` 函数, 代币授权逻辑
    function approve(
        address spender,
        uint256 amount
    ) external override returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approve(msg.sender, spender, amount);
        return true;
    }

    // @dev 实现`transferFrom`函数，代币授权转账逻辑
    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external override returns (bool) {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Trancefer(sender, recipient, amount);
        return true;
    }

    // @dev 铸造代币，从 `0` 地址转账给 调用者地址
    function mint(uint amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Trancefer(address(0), msg.sender, amount);
    }

    // @dev 销毁代币，从 调用者地址 转账给  `0` 地址
    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Trancefer(msg.sender, address(0), amount);
    }
}

/**
 * 1、ERC20代币的水龙头合约
 * 2、实现逻辑：用户触发领取代币动作，调用ERC20代币合约开始转账代币到用户账户余额
 */
contract Faucet {
    uint256 public amountAllowed = 100; // 每次领 100单位代币
    address public tokenContract; // token合约地址（即上面ERC20部署的合约地址，传入初始化中）

    mapping(address => bool) public requestedAddress; // 记录领取过代币的地址

    event SendToken(address indexed Receiver, uint256 indexed Amount);

    // 部署时设定ERC20代币合约
    constructor(address _tokenContract) {
        tokenContract = _tokenContract;
    }

    // 用户领取代币函数
    function requestTokens() external {
        require(!requestedAddress[msg.sender], "Can't Request Multiple Times!");
        IERC20 token = IERC20(tokenContract);
        require(
            token.balanceOf(address(this)) >= amountAllowed,
            "Faucet Empty!"
        );

        token.transfer(msg.sender, amountAllowed);
        requestedAddress[msg.sender] = true;

        emit SendToken(msg.sender, amountAllowed);
    }
}
