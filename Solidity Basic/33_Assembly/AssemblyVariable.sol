// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev 内联汇编 变量声明
 */
contract AssemblyVariable {
    function yul_let() public pure returns (uint z) {
        assembly {
            let x := 123
            z := 456
        }
    }
}
