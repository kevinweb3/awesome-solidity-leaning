// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.4;

contract ValeTypes {
    // 布尔值
    bool public _bool = true;
    // 布尔运算
    bool public _bool1 = !_bool;
    bool public _bool2 = _bool && _bool1;
    bool public _bool3 = _bool || _bool1;
    bool public _bool4 = _bool == _bool1;
    bool public _bool5 = _bool != _bool1;

    // 整数
    int public _int = -1;
    uint public _uint = 1;
    uint256 public _number = 20230820;

    // 整数运算
    uint256 public _number1 = _number + 1; // +，-，*，/
    uint256 public _number2 = 2**2; // 指数
    uint256 public _number3 = 7 % 2; // 取余数
    bool public _numberbool = _number2 > _number3; // 比大小

    // 地址
    address public _address = 0x7A58C0BE72Be218B41C608b7FE7C5Bb630736C46;
    // payable address，可以转账、查余额
    address payable public _address1 = payable(_address);
    uint256 public balance = _address1.balance; // 查看余额

    // 固定长度的字节数组
    bytes32 public _byte32 = "KeivinYesr";
    bytes1 public _byte = _byte32[0];

    // Enum
    // 将uint 0, 1, 2表示为Buy, Hold, Sell
    enum ActiionSet {
        Buy,
        Hold,
        Sell
    }
    // 创建enum变量 action
    ActiionSet action = ActiionSet.Buy;

    // enum可以和uint显示转换
    function enumToUint() external view returns(uint) {
        return uint(action);
    }
}