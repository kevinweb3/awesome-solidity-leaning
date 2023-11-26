// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev 算术运算不检查模式 unchecked, 即在发生溢出的情况下会进行截断，不会触发失败异常
 * @dev 默认检查模式 unchecked, 溢出会触发失败异常
 */
contract uncheckedMath {
    function add(uint x, uint y) external pure returns (uint) {
        unchecked {
            return x + y;
        }
    }

    function sub(uint x, uint y) external pure returns (uint) {
        unchecked {
            return x - y;
        }
    }

    function sumOfCubes(uint x, uint y) external pure returns (uint) {
        unchecked {
            uint x3 = x * x * x;
            uint y3 = y * y * y;
            return x3 + y3;
        }
    }
}
