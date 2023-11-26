// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev 内联汇编 IF
 */

contract AssemblyIf {
    function yul_if(uint x) public pure returns (uint z) {
        assembly {
            if lt(x, 10) {
                z := 99
            }
        }
    }

    function yul_switch(uint x) public pure returns (uint z) {
        assembly {
            switch x
            case 1 {
                z := 10
            }
            case 2 {
                z := 20
            }
            default {
                z := 0
            }
        }
    }
}
