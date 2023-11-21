// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.4;

contract Overload {
    function saySomething() public pure returns(string memory) {
        return("Nothing");
    }

    function saySomething(string memory something) public pure returns(string memory) {
        return(something);
    }

    function f(uint8 _in) public pure returns(uint8 out) {
        out = _in;
    }

    function f(uint256 _in) public pure returns(uint256 out) {
        out = _in;
    }
}

/*
    重载:
    solidity中允许函数进行重载（overloading），即名字相同但输入参数类型不同的函数可以同时存在，他们被视为不同的函数。注意，solidity不允许修饰器（modifier）重载。


    函数重载:
    举个例子，我们可以定义两个都叫saySomething()的函数，一个没有任何参数，输出"Nothing"；另一个接收一个string参数，输出这个string


    实参匹配（Argument Matching）:
    在调用重载函数时，会把输入的实际参数和函数参数的变量类型做匹配。
    如果出现多个匹配的重载函数，则会报错。下面这个例子有两个叫f()的函数，一个参数为uint8，另一个为uint256：

*/