// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract OnlyEven{
    constructor(uint a) {
        require(a != 0, "invalid number");
        assert(a != 0);
    }

    function onlyEven(uint256 b) external pure returns(bool success) {
        require(b %2 == 0, "invalid number");
        success = true;
    }
}

contract TryCatch {
    event SuccessEvent();
    event CatchEvent(string message);
    event CatchByte(bytes data);

    OnlyEven even;

    constructor() {
        even = new OnlyEven(2);
    }

    // 在external call中使用try-catch
    // execute(0)会成功并释放`SuccessEvent`
    // execute(1)会失败并释放`CatchEvent`
    function execute(uint amount) external returns(bool success) {
        try even.onlyEven(amount) returns (bool _success) {
            // call成功的情况下
            emit SuccessEvent();
            return _success;
        } catch  Error(string memory reason){
            // call不成功的情况下
            emit CatchEvent(reason);
        }
    }

    // 在创建新合约中使用try-catch （合约创建被视为external call）
    // executeNew(0)会失败并释放`CatchEvent`
    // executeNew(1)会失败并释放`CatchByte`
    // executeNew(2)会成功并释放`SuccessEvent`
    function executeNew(uint a) external returns (bool success) {
        try new OnlyEven(a) returns(OnlyEven _even){
            // call成功的情况下
            emit SuccessEvent();
            success = _even.onlyEven(a);
        } catch Error(string memory reason) {
            // catch revert("reasonString") 和 require(false, "reasonString")
            emit CatchEvent(reason);
        } catch (bytes memory reason) {
            // catch失败的assert assert失败的错误类型是Panic(uint256) 不是Error(string)类型 故会进入该分支
            emit CatchByte(reason);
        }
    }
}


/*
    try-catch
    在solidity中，try-catch只能被用于external函数或创建合约时constructor（被视为external函数）的调用。基本语法如下：
    try externalContract.f() {
        // call成功的情况下 运行一些代码
    } catch {
        // call失败的情况下 运行一些代码
    }

    其中externalContract.f()是某个外部合约的函数调用，try模块在调用成功的情况下运行，而catch模块则在调用失败时运行。

    同样可以使用this.f()来替代externalContract.f()，this.f()也被视作为外部调用，但不可在构造函数中使用，因为此时合约还未创建。

    如果调用的函数有返回值，那么必须在try之后声明returns(returnType val)，并且在try模块中可以使用返回的变量；如果是创建合约，那么返回值是新创建的合约变量。


*/