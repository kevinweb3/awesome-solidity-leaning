// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "./ERC721.sol";

contract ZHWnft is ERC721 {
    uint public MAX_NUM = 50000; // 发行总量

    constructor(
        string memory name_,
        string memory symbol_
    ) ERC721(name_, symbol_) {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/";
    }

    // 铸造函数
    function mint(address to, uint tokenId) external {
        require(tokenId >= 0 && tokenId < MAX_NUM, "tokenId out of range");
        _mint(to, tokenId);
    }
}
