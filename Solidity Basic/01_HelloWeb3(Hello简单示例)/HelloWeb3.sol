// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

/**
 * @dev 先来一个Hello Web3 热身
 */
contract HelloWeb3 {
    string public greet = "Hello Web3!";
    uint8 public num;

    function set() public {
        num += 1;
    }

    function get() public view returns (uint8) {
        return num;
    }

    function getOwner() public view returns (address) {
        return msg.sender;
    }
}