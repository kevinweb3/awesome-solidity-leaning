// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ERC20.sol";
import "./Ownable.sol";

contract MintableToken is ERC20, Ownable {
    event Mint(address indexed to, uint256 amount);
    event MintFinished();

    bool public mintingFinished = false;

    modifier canMint() {
        require(!mintingFinished);
        _;
    }

    /**
     * @dev Function to mint tokens
     * @param _to The address that will receive the minted tokens.
     * @param _amount The amount of tokens to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(
        address _to,
        uint256 _amount
    ) public onlyOwner canMint returns (bool) {
        totalSupply = totalSupply.add(_amount);
        balanceOf[_to] = balanceOf[_to].add(_amount);
        emit Mint(_to, _amount);
        Transfer(0x0, _to, _amount);
        return true;
    }

    /**
     * @dev Function to stop minting new tokens.
     * @return True if the operation was successful.
     */
    function finishMinting() public onlyOwner returns (bool) {
        mintingFinished = true;
        MintFinished();
        return true;
    }
}

contract TestToken is MintableToken {
    string public name;
    string public symbol;
    uint8 public decimals;

    function _TestToken(string _name, string _symbol, uint8 _decimals) public {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }
}
