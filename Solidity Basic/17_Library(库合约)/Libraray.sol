// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

library StringLibrary {
    bytes private constant _HEX_SYMBOLS = "0123456789abcdef";

     /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) public pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

   /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) public pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) public pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }

}

// 用函数调用另一个库合约
contract UseLibrary {
    // 利用using for 操作使用库
    using StringLibrary for uint256;
    function getString1(uint256 _number) public pure returns(string memory) {
        // 库函数会自动添加为uint256型变量的成员
        return _number.toHexString();
    }

    // 直接调用库合约名调用
    function getString2(uint256 _number) public pure returns(string memory) {
        return StringLibrary.toHexString(_number);
    }
}

/*
    库合约
    库合约是一种特殊的合约，为了提升solidity代码的复用性和减少gas而存在。库合约是一系列的函数合集，由大神或者项目方创作，咱们站在巨人的肩膀上，会用就行了。（类似于其他语言的插件库）

    他和普通合约主要有以下几点不同：
    1、不能存在状态变量
    2、不能够继承或被继承
    3、不能接收以太币
    4、不可以被销毁

    库合约的使用：
    1. 利用using for指令
    指令using A for B;可用于附加库合约（从库 A）到任何类型（B）。添加完指令后，库A中的函数会自动添加为B类型变量的成员，可以直接调用。注意：在调用的时候，这个变量会被当作第一个参数传递给函数：

    2. 通过库合约名称调用函数

    常用的库合约：
    String：将uint256转换为String
    (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/4a9cc8b4918ef3736229a5cc5a310bdc17bf759f/contracts/utils/Strings.sol)

    Address：判断某个地址是否为合约地址
    (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/4a9cc8b4918ef3736229a5cc5a310bdc17bf759f/contracts/utils/Address.sol)

    Create2：更安全的使用Create2 EVM opcode
    (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/4a9cc8b4918ef3736229a5cc5a310bdc17bf759f/contracts/utils/Create2.sol)

    Arrays：跟数组相关的库合约
    (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/4a9cc8b4918ef3736229a5cc5a310bdc17bf759f/contracts/utils/Arrays.sol)
*/