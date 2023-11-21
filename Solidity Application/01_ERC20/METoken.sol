// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract MyToken is ERC20, ERC20Burnable, Ownable, ERC20Permit {
    constructor(
        address initialOwner
    ) ERC20("MyToken", "MTK") Ownable(initialOwner) ERC20Permit("MyToken") {
        _mint(msg.sender, 100 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
