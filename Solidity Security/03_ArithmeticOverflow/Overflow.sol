// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev 整型溢出
 */
contract Overflow {
    mapping(address => uint) balances;
    uint public totalSupply;

    constructor(uint _initialSupply) {
        balances[msg.sender] = totalSupply = _initialSupply;
    }

    function transfer(address _to, uint _value) public returns (bool) {
        // `require(balances[msg.sender] - _value >= 0);` 这个检查由于整型溢出，永远都会通过。因此用户可以无限转账。
        unchecked {
            require(balances[msg.sender] - _value >= 0);
            balances[msg.sender] -= _value;
            balances[_to] += _value;
        }
        return true;
    }

    function balanceOf(address _owner) public view returns (uint balance) {
        return balances[_owner];
    }
}
