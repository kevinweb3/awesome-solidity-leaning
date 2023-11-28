// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev ERC1155 批量铸造NFT
 */

import "./ERC1155.sol";

contract MyERC1155 is ERC1155 {
    uint256 constant MAX_ID = 10000;

    constructor() ERC1155("BAYC1155", "BAYC1155") {}

    // baseURI为ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/
    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/";
    }

    // 铸造函数
    function mint(address to, uint256 id, uint256 amount) external {
        // id 不能超过10,000
        require(id < MAX_ID, "id overflow");
        _mint(to, id, amount, "");
    }

    // 批量铸造函数
    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts
    ) external {
        // id 不能超过10,000
        for (uint256 i = 0; i < ids.length; i++) {
            require(ids[i] < MAX_ID, "id overflow");
        }
        _mintBatch(to, ids, amounts, "");
    }

    // 销毁函数
    function burn(uint256 id, uint256 value) external {
        _burn(msg.sender, id, value);
    }

    // 批量销毁函数
    function batchBurn(
        uint256[] calldata ids,
        uint256[] calldata values
    ) external {
        _burnBatch(msg.sender, ids, values);
    }
}
