// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.4;

// 应用类型 Array
contract ArrayTypes {

    // 固定长度的 Array
    uint[8] array1;
    uint[5] array2;
    uint[90] array3;

    // 可变长度 Array
    uint[] array4;
    bytes[] array5;
    address[] array6;
    bytes array7;

    // 初始化可变长度 Array
    uint[] array8 = new uint[](5);
    bytes array9 = new bytes(9);

    // 给可变长度数组赋值
    function initArray() external pure returns(uint[] memory) {
        uint[] memory x = new uint[](3);
        x[0] = 1;
        x[1] = 3;
        x[2] = 4;
        return(x);
    }

    function arrayPush() public returns(uint[] memory) {
        uint[2] memory a = [uint(1), 2];
        array4 = a;
        array4.push(3);
        array4.pop();
        return array4;
    }
}

// 应用类型 Struct
contract structTypes {
    struct Student {
        uint256 id;
        uint256 score;
    }

    // 初始化一个student的结构体
    Student student;

    // 给结构体赋值的4种方式
    // 方式1：在函数中创建一个storage的struct引用
    function initStudent1() external {
        Student storage _student = student;
        _student.id = 11;
        _student.score = 100;
    }

    // 方式2：直接引用状态变量的struct
    function initStudent12() external {
        student.id = 1;
        student.score = 95;
    }

    // 方式3：构造函数式
    function initStudent3() external {
        student = Student(3, 90);
    }

    // 方式4：key value
    function initStudent4() external {
        student = Student({
            id: 4,
            score: 75
        });
    }
}

// 应用类型 Enum
contract EnumTypes {
    // 将uint 0, 1, 2表示为Buy, Hold, Sell
    enum ActionSet {
        Buy,
        Hold,
        Sell
    }

    // 创建enum变量 action
    ActionSet action = ActionSet.Buy;

    // enum可以和uint显示的转换
    function enumToUint() external view returns(uint) {
        return uint(action);
    }

    function get() public view returns (ActionSet) {
        return action;
    }

    // Update status by passing uint into input
    function set(ActionSet _status) public {
        action = _status;
    }

    // You can update to a specific enum like this
    function cancel() public {
        action = ActionSet.Sell;
    }

    // delete resets the enum to its first value, 0
    function reset() public {
        delete action;
    }
}