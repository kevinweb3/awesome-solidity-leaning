// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// delegatecall和call类似，都是低级函数
// call: B call C, 上下文为 C (msg.sender = B, C中的状态变量受影响)
// delegatecall: B delegatecall C, 上下文为B (msg.sender = A, B中的状态变量受影响)
// 注意B和C的数据存储布局必须相同！变量类型、声明的前后顺序要相同，不然会搞砸合约。

// 被调用的合约C
contract C {
    uint public num;
    address public sender;

    function setVars(uint _num) public payable {
        num = _num;
        sender = msg.sender;
    }
}

// 发起delegatecall的合约B
contract B {
    uint public num;
    address public sender;

    // 通过call来调用C的setVars()函数，将改变合约C里的状态变量
    function callSetVars(address _addr, uint _num) external payable{
        // call setVars()
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }
    // 通过delegatecall来调用C的setVars()函数，将改变合约B里的状态变量
    function delegatecallSetVars(address _addr, uint _num) external payable{
        // delegatecall setVars()
        (bool success, bytes memory data) = _addr.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }
}

/*
    delegatecall
    delegatecall与call类似，是solidity中地址类型的低级成员函数。

    什么情况下会用到delegatecall?
    目前delegatecall主要有两个应用场景：

    代理合约（Proxy Contract）：将智能合约的存储合约和逻辑合约分开：代理合约（Proxy Contract）存储所有相关的变量，并且保存逻辑合约的地址；所有函数存在逻辑合约（Logic Contract）里，通过delegatecall执行。当升级时，只需要将代理合约指向新的逻辑合约即可。

    EIP-2535 Diamonds（钻石）：钻石是一个支持构建可在生产中扩展的模块化智能合约系统的标准。钻石是具有多个实施合约的代理合约。

*/
