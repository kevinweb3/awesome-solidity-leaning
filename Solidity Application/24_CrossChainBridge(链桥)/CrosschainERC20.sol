// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../openzeppelin/token/ERC20/ERC20.sol";
import "../../openzeppelin/access/Ownable.sol";

contract CrossChainToken is ERC20 {
    address public owner;
    // Bridge event
    event Bridge(address indexed user, uint256 amount);
    // Mint event
    event Mint(address indexed to, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor(
        string memory name,
        string memory symbol,
        uint256 totalSupply
    ) payable ERC20(name, symbol) {
        owner = msg.sender;
        _mint(msg.sender, totalSupply);
    }

    function bridge(uint256 amount) public {
        _burn(msg.sender, amount);
        emit Bridge(msg.sender, amount);
    }

    function mint(address to, uint amount) external onlyOwner {
        _mint(to, amount);
        emit Mint(to, amount);
    }
}
