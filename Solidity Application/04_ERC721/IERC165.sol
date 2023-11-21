// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

/**
 * @dev ERC165接口，ERC165就是检查一个智能合约是不是支持了`ERC721`，`ERC1155`的接口
 * 合约可以声明支持的接口，供其他合约检查
 */

interface IERC165 {
    /**
     * @dev 如果合约实现了查询的`interfaceId`，则返回true
     */

    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}
