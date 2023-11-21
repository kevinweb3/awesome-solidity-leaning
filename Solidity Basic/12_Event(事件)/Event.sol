// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.4;

// 事件Event
contract Event {
    // 定义_balances映射变量，记录每个地址的持币数量
    mapping(address => uint256) public _balances;

    // 定义Transfer event, 记录transfer交易的转账地址，接收地址和转账数量
    event Transfer(address indexed from, address indexed to, uint256 value);

    // 定义_transfer函数，执行转账逻辑
    function _transfer(address from, address to, uint256 amount) external {
        _balances[from] = 10000000; // 给转账地址一些初始代币
        _balances[from] -= amount; // from地址减去转账数量
        _balances[to] += amount; // to地址加上转账数量

        // 释放事件
        emit Transfer(from, to, amount);
    }
}

/*
    事件的特点：
    响应：应用程序（ethers.js）可以通过RPC接口订阅和监听这些事件，并在前端做响应。
    经济：事件是EVM上比较经济的存储数据的方式，每个大概消耗2,000 gas；相比之下，链上存储一个新变量至少需要20,000 gas

    声明事件：
    事件的声明由event关键字开头，接着是事件名称，括号里面写好事件需要记录的变量类型和变量名。

    释放事件：
    我们可以在函数里释放事件

    EVM日志 Log：
    太坊虚拟机（EVM）用日志Log来存储Solidity事件，每条日志记录都包含主题topics和数据data两部分

    数据 data：
    事件中不带 indexed的参数会被存储在 data 部分中，可以理解为事件的“值”。data 部分的变量不能被直接检索，但可以存储任意大小的数据。因此一般 data 部分可以用来存储复杂的数据结构，例如数组和字符串等等，因为这些数据超过了256比特，即使存储在事件的 topics 部分中，也是以哈希的方式存储。另外，data 部分的变量在存储上消耗的gas相比于 topics 更少。
*/