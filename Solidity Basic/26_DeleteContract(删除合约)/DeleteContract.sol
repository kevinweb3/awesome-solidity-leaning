// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.4;

contract DeleteContract {
    uint public value = 10;
    constructor() payable {}
    receive() external payable {}
    function deleteContract() external {
        selfdestruct(payable(msg.sender));
    }

    function gerBalance() external view returns(uint balance) {
        balance = address(this).balance;
    }
}

/*
    selfdestruct
    selfdestruct命令可以用来删除智能合约，并将该合约剩余ETH转到指定地址。selfdestruct是为了应对合约出错的极端情况而设计的。

    如何使用selfdestruct
    selfdestruct使用起来非常简单：elfdestruct(_addr)；

    当我们调用deleteContract()函数，合约将自毁，所有变量都清空，此时value变为默认值0，getBalance()也返回空值。


*/