// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// 合约继承
contract Yeye {
    event Log(string msg);

    function hip() public virtual {
        emit Log("Yeye");
    }

    function pop() public virtual {
        emit Log("Yeye");
    }

    function yeye() public virtual {
        emit Log("Yeye");
    }
}

contract Baba is Yeye {
    function hip() public virtual override {
        emit Log("Baba");
    }

    function pop() public virtual override {
        emit Log("Baba");
    }

    function baba() public virtual {
        emit Log("Baba");
    }
}

contract Erzi is Yeye, Baba {
    // 继承两个function: hip()和pop()，输出改为Erzi。
    function hip() public virtual override(Yeye, Baba) {
        emit Log("Erzi");
    }

    function pop() public virtual override(Yeye, Baba) {
        emit Log("Erzi");
    }

    function callParent() public {
        Yeye.pop();
    }

    function callParentSuper() public {
        super.pop();
    }
}

// 构造函数的继承
abstract contract A {
    uint public a;

    constructor(uint _a) {
        a = _a;
    }
}

contract B is A(1) {}

contract C is A {
    constructor(uint _c) A(_c * _c) {}
}

// Base contract X
contract X {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }
}

// Base contract Y
contract Y {
    string public text;

    constructor(string memory _text) {
        text = _text;
    }
}

// There are 2 ways to initialize parent contract with parameters.

// Pass the parameters here in the inheritance list.
contract M is X("Input to X"), Y("Input to Y") {

}

contract N is X, Y {
    // Pass the parameters here in the constructor,
    // similar to function modifiers.
    constructor(string memory _name, string memory _text) X(_name) Y(_text) {}
}

/*
    继承
    继承是面向对象编程很重要的组成部分，可以显著减少重复代码。如果把合约看作是对象的话，solidity也是面向对象的编程，也支持继承。

    规则：
    1、virtual: 父合约中的函数，如果希望子合约重写，需要加上virtual关键字。
    2、override：子合约重写了父合约中的函数，需要加上override关键字。

    简单继承
    我们先写一个简单的爷爷合约Yeye，里面包含1个Log事件和3个function: hip(), pop(), yeye()，输出都是”Yeye”。

    多重继承：
    solidity的合约可以继承多个合约。规则：

    继承时要按辈分最高到最低的顺序排。比如我们写一个Erzi合约，继承Yeye合约和Baba合约，那么就要写成contract Erzi is Yeye, Baba，而不能写成contract Erzi is Baba, Yeye，不然就会报错。

    如果某一个函数在多个继承的合约里都存在，比如例子中的hip()和pop()，在子合约里必须重写，不然会报错。

    重写在多个父合约中都重名的函数时，override关键字后面要加上所有父合约名字，例如override(Yeye, Baba)。

    修饰器的继承：
    Solidity中的修饰器（Modifier）同样可以继承，用法与函数继承类似，在相应的地方加virtual和override关键字即可。

    构造函数的继承：
    子合约有两种方法继承父合约的构造函数。举个简单的例子，父合约A里面有一个状态变量a，并由构造函数的参数来确定：

    调用父合约的函数：
    子合约有两种方式调用父合约的函数，直接调用和利用super关键字。

    直接调用：子合约可以直接用父合约名.函数名()的方式来调用父合约函数，例如Yeye.pop()。
    super关键字：子合约可以利用super.函数名()来调用最近的父合约函数。solidity继承关系按声明时从右到左的顺序是：contract Erzi is Yeye, Baba，那么Baba是最近的父合约，super.pop()将调用Baba.pop()而不是Yeye.pop()：
*/
