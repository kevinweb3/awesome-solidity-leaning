// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "./IERC165.sol";

/**
 * @dev ERC721标准接口，包含3个事件和9个函数
 * Transfer事件：在转账时被释放，记录代币的发出地址from，接收地址to和tokenid。
 * Approval事件：在授权时释放，记录授权地址owner，被授权地址approved和tokenid。
 * ApprovalForAll事件：在批量授权时释放，记录批量授权的发出地址owner，被授权地址operator和授权与否的approved。
 * balanceOf：返回某地址的NFT持有量balance。
 * ownerOf：返回某tokenId的主人owner。
 * transferFrom：普通转账，参数为转出地址from，接收地址to和tokenId。
 * safeTransferFrom：安全转账（如果接收方是合约地址，会要求实现ERC721Receiver接口）。参数为转出地址from，接收地址to和tokenId。
 * approve：授权另一个地址使用你的NFT。参数为被授权地址approve和tokenId。
 * getApproved：查询tokenId被批准给了哪个地址。
 * setApprovalForAll：将自己持有的该系列NFT批量授权给某个地址operator。
 * isApprovedForAll：查询某地址的NFT是否批量授权给了另一个operator地址。
 * safeTransferFrom：安全转账的重载函数，参数里面包含了data。
 */

interface IERC721 is IERC165 {
    // Transfer事件：在转账时被释放，记录代币的发出地址from，接收地址to和tokenid。
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    // Approval事件：在授权时释放，记录授权地址owner，被授权地址approved和tokenid。
    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );

    // ApprovalForAll事件：在批量授权时释放，记录批量授权的发出地址owner，被授权地址operator和授权与否的approved。
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    // balanceOf：返回某地址的NFT持有量balance。
    function balanceOf(address owner) external view returns (uint256 balance);

    // ownerOf：返回某tokenId的主人owner。
    function ownerOf(uint256 tokenId) external view returns (address owner);

    // safeTransferFrom：安全转账的重载函数，参数里面包含了data。
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    // safeTransferFrom：安全转账（如果接收方是合约地址，会要求实现ERC721Receiver接口）。参数为转出地址from，接收地址to和tokenId。
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    // transferFrom：普通转账，参数为转出地址from，接收地址to和tokenId。
    function transferFrom(address from, address to, uint256 tokenId) external;

    // approve：授权另一个地址使用你的NFT。参数为被授权地址approve和tokenId。
    function approve(address to, uint256 tokenId) external;

    // setApprovalForAll：将自己持有的该系列NFT批量授权给某个地址operator。
    function setApprovalForAll(address operator, bool _approved) external;

    // getApproved：查询tokenId被批准给了哪个地址。
    function getApproved(
        uint256 tokenId
    ) external view returns (address operator);

    // isApprovedForAll：查询某地址的NFT是否批量授权给了另一个operator地址。
    function isApprovedForAll(
        address owner,
        address operator
    ) external view returns (bool);
}
