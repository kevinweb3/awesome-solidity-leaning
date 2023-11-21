// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.4;

contract FuntionTypes {
    uint256 public number = 5;

    constructor() payable {

    }

    // 函数类型
    // function <function name>(<parameter types>) {internal|external|public|private} [pure|view|payable] [returns (<return types>)]
    function add() external {
        number = number + 1;
    }

    // pure 
    function addPure(uint256 _number) external pure returns(uint256 new_number) {
        new_number = _number + 1;
    }

    // view
    function addView() external view returns(uint256 new_number) {
        new_number = number + 1;
    }

    // internal
    function minus() internal {
        number = number -1;
    }

    // 合约内的函数可以调用内部函数
    function minusCall() external {
        minus();
    }

    // payable: 能给合约支付ETH的函数
    function minusPayable() external payable returns(uint256 balance) {
        minus();
        balance = address(this).balance;
    }
}

/*
    Solidity中函数的基本形式：
    function <function name>(<parameter types>) {internal|external|public|private} [pure|view|payable] [returns (<return types>)]
    
    说明：
    1. function：声明函数时的固定用法。要编写函数，就需要以 function 关键字开头。
    2. <function name>：函数名。
    3. (<parameter types>)：圆括号内写入函数的参数，即输入到函数的变量类型和名称。
    4. {internal|external|public|private}：函数可见性说明符，共有4种。
        public：内部和外部均可见。
        private：只能从本合约内部访问，继承的合约也不能使用。
        external：只能从合约外部访问（但内部可以通过 this.f() 来调用，f是函数名）。
        internal: 只能从合约内部访问，继承的合约可以用。
    5. [pure|view|payable]：决定函数权限/功能的关键字。payable（可支付的）很好理解，带着它的函数，运行的时候可以给合约转入 ETH。
    6. [returns ()]：函数返回的变量类型和名称。

    Pure 和View：
    pure 和 view 关键字的函数是不改写链上状态的，因此用户直接调用它们是不需要付 gas 的（注意，合约中非 pure/view 函数调用 pure/view 函数时需要付gas）。

    在以太坊中，以下语句被视为修改链上状态：
        1、写入状态变量。
        2、释放事件。
        3、创建其他合约。
        4、使用 selfdestruct.
        5、通过调用发送以太币。
        6、调用任何未标记 view 或 pure 的函数。
        7、使用低级调用（low-level calls）。
        8、使用包含某些操作码的内联汇编。

*/