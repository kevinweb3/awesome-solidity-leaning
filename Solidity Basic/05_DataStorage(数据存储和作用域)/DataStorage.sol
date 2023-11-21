// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract DataStoreage {
    uint[] public x = [1, 2, 3];

    function fStrorage() public {
        // 声明一个storage的变量xStorage，指向x，修改xStorage也会影响x
        uint[] storage xStorage = x;
        xStorage[0] = 100;
    }

    function fMemory() public view {
        // 声明一个Memory的变量xMomory, 复制x，修改xMomery不会影响x
        uint[] memory xMemory = x;
        xMemory[0] = 100;
        xMemory[1] = 200;
        uint[] memory xMemory2 = x;
        xMemory2[0] = 300;
    }

    function fCalldata(
        uint[] calldata _x
    ) public pure returns (uint[] calldata) {
        // 参数为calldata数组，不能被修改
        // _x[0] = 0
        return (_x);
    }
}

contract Variables {
    uint public x = 1;
    uint public y;
    string public z;

    function foo() external {
        // 可以在函数里更改状态变量的值
        x = 5;
        y = 2;
        z = "0xAA";
    }

    function bar() external pure returns (uint) {
        uint xx = 1;
        uint yy = 3;
        uint zz = xx + yy;
        return (zz);
    }

    function globle() external view returns (address, uint, bytes memory) {
        address sender = msg.sender;
        uint blockNum = block.number;
        bytes memory data = msg.data;
        return (sender, blockNum, data);
    }

    function weiUnit() external pure returns (uint) {
        assert(1 wei == 1e0);
        assert(1 wei == 1);
        return 1 wei;
    }

    function gweiUnit() external pure returns (uint) {
        assert(1 gwei == 1e9);
        assert(1 gwei == 1000000000);
        return 1 gwei;
    }

    function etherUnit() external pure returns (uint) {
        assert(1 ether == 1e18);
        assert(1 ether == 1000000000000000000);
        return 1 ether;
    }

    function secondsUnit() external pure returns (uint) {
        assert(1 seconds == 1);
        return 1 seconds;
    }

    function minutesUnit() external pure returns (uint) {
        assert(1 minutes == 60);
        assert(1 minutes == 60 seconds);
        return 1 minutes;
    }

    function hoursUnit() external pure returns (uint) {
        assert(1 hours == 3600);
        assert(1 hours == 60 minutes);
        return 1 hours;
    }

    function daysUnit() external pure returns (uint) {
        assert(1 days == 86400);
        assert(1 days == 24 hours);
        return 1 days;
    }

    function weeksUnit() external pure returns (uint) {
        assert(1 weeks == 604800);
        assert(1 weeks == 7 days);
        return 1 weeks;
    }
}

/*
    Solidity中的引用类型
    引用类型(Reference Type)：包括数组（array）和结构体（struct），由于这类变量比较复杂，占用存储空间大，我们在使用时必须要声明数据存储的位置。

    solidity数据存储位置有三类：storage，memory和calldata。不同存储位置的gas成本不同。storage类型的数据存在链上，类似计算机的硬盘，消耗gas多；memory和calldata类型的临时存在内存里，消耗gas少。大致用法：

    1、storage：合约里的状态变量默认都是storage，存储在链上。
    2、memory：函数里的参数和临时变量一般用memory，存储在内存中，不上链。
    3、calldata：和memory类似，存储在内存中，不上链。与memory的不同点在于calldata变量不能修改（immutable），一般用于函数的参数。

    -----

    数据位置和赋值规则：
    在不同存储类型相互赋值时候，有时会产生独立的副本（修改新变量不会影响原变量），有时会产生引用（修改新变量会影响原变量）。规则如下：

    赋值本质上是创建引用指向本体，因此修改本体或者是引用，变化可以被同步：
    1、storage（合约的状态变量）赋值给本地storage（函数里的）时候，会创建引用，改变新变量会影响原变量。
    2、memory赋值给memory，会创建引用，改变新变量会影响原变量。
    3、其他情况下，赋值创建的是本体的副本，即对二者之一的修改，并不会同步到另一方

    memory 用于仅在函数执行过程中需要的临时变量， calldata 用于从外部调用者传入的函数参数，并且不能修改， storage 用于将数据永久存储在区块链上，合约中的任何函数都可以访问和修改这些数据

    -----

    常用的内置全局变量：
    1、blockhash(uint blockNumber): (bytes32)给定区块的哈希值 – 只适用于256最近区块, 不包含当前区块。
    2、block.coinbase: (address payable) 当前区块矿工的地址
    3、block.gaslimit: (uint) 当前区块的gaslimit
    4、block.number: (uint) 当前区块的number
    5、block.timestamp: (uint) 当前区块的时间戳，为unix纪元以来的秒
    6、gasleft(): (uint256) 剩余 gas
    7、msg.data: (bytes calldata) 完整call data
    8、msg.sender: (address payable) 消息发送者 (当前 caller)
    9、msg.sig: (bytes4) calldata的前四个字节 (function identifier)
    10、msg.value: (uint) 当前交易发送的wei值

    全局变量-以太单位与时间单位：
    以太单位：
    wei: 1
    gwei: 1e9 = 1000000000
    ether: 1e18 = 1000000000000000000

    时间单位：
    seconds: 1
    minutes: 60 seconds = 60
    hours: 60 minutes = 3600
    days: 24 hours = 86400
    weeks: 7 days = 604800

*/
