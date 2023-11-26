// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev 钱包
 */

contract EtherWallet {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    // 接收转账ETH，任何人可以发送ETH
    receive() external payable {}

    // 提现
    function withdraw(uint256 _amount) external {
        require(msg.sender == owner, "caller is not owner");
        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        require(success, "withdraw failed");
    }

    // 获取账户余额
    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}
