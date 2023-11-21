// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// ERC20代币合约实现

import "./IERC20.sol";
import "./SafeMath.sol";

/**
 * 1、在合约部署的时候实现合约名称和符号初始化
 * 2、实现了5个函数（代币转账、代币授权、代币授权转账、铸造代币、销毁代币）
 */
contract ERC20 is IERC20 {
    using SafeMath for uint256;

    // 合约执行者代币余额
    mapping(address => uint256) public override balanceOf;

    // 代币授权额度
    mapping(address => mapping(address => uint256)) public override allowance;

    // 代币总供给
    uint256 public override totalSupply;

    // 代币名称
    string public name;

    // 代币符号
    string public symbol;

    // 代币小数位数
    uint8 public decimals = 18;

    // @dev 在合约部署的时候实现合约名称和符号初始化
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
