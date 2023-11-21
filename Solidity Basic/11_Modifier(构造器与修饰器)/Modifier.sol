// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.4;

// 构造函数和修饰器
contract Modifider {
    address public owner;

    // 构造函数，初始化合约的一些参数
    constructor() {
        // 在部署合约的时候，将owner设置为部署者的地址
        owner = msg.sender;
    }

    // 定义修饰器modifier，modifier的主要使用场景是运行函数前的检查，例如地址，变量，余额等。
    modifier onlyOwner {
        // 检查调用者是否为owner地址
        require(msg.sender == owner);
        _; // 如果是的话，继续运行函数主体；否则报错并revert交易
    }

    // 定义一个带onlyOwner修饰符的函数，带有onlyOwner修饰符的函数只能被owner地址调用
    function changeOWner(address _newOwner) external onlyOwner {
        // 只有owner地址运行这个函数，并改变owner
        owner = _newOwner;
    }
}