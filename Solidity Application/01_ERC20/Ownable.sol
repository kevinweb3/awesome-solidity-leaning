// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Ownable {
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function _Ownable() public {
        owner = msg.sender;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}
