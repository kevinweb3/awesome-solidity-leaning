// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "../04_ERC721/IERC721.sol";
import "../04_ERC721/IERC721Receiver.sol";
import "../04_ERC721/ZHWnft.sol";

/**
 * @dev NFTSwap 过程解析，4个Event事件
 * 1、挂单: 卖家上架NFT
 * 2、购买: 买家购买NFT
 * 3、撤单： 卖家取消挂单
 * 4、调整价格: 卖家调整挂单价格
 */
contract NFTSwap is IERC721Receiver {
    // 卖家挂单事件
    event List(
        address indexed seller,
        address indexed nftAddr,
        uint256 indexed tokenId,
        uint256 price
    );

    // 买家购买事件
    event Purchase(
        address indexed buyer,
        address indexed nftAddr,
        uint256 indexed tokenId,
        uint256 price
    );

    // 卖家取消挂单事件
    event Revoke(
        address indexed seller,
        address indexed nftAddr,
        uint256 indexed tokenId
    );

    // 卖家调整挂单价格事件
    event Update(
        address indexed seller,
        address indexed nftAddr,
        uint256 indexed tokenId,
        uint256 newPrice
    );

    // 定义order结构体
    struct Order {
        address owner;
        uint256 price;
    }

    // NFT Order映射
    mapping(address => mapping(uint256 => Order)) public nftList;

    /**
     * @dev 挂单: 卖家上架NFT，合约地址为_nftAddr，tokenId为_tokenId，价格_price为以太坊（单位是wei）
     * 1、实例化nft合约；
     * 2、创建nft订单；
     * 3、设置订单持有人和价格；
     * 4、将NFT转账到合约；
     * 5、释放挂单事件
     */
    function list(address _nftAddr, uint256 _tokenId, uint256 _price) public {
        // 声明IERC721接口合约变量
        IERC721 _nft = IERC721(_nftAddr);
        // 合约得到授权
        require(_nft.getApproved(_tokenId) == address(this), "can't access");
        require(_price > 0); // 价格大于0

        // 设置NFT持有人和价格
        Order storage _order = nftList[_nftAddr][_tokenId];
        _order.owner = msg.sender;
        _order.price = _price;

        // 将NFT转账到合约
        _nft.safeTransferFrom(msg.sender, address(this), _tokenId);

        // 释放挂单事件
        emit List(msg.sender, _nftAddr, _tokenId, _price);
    }

    /**
     * @dev 购买: 买家购买NFT，合约为_nftAddr，tokenId为_tokenId，调用函数时要附带ETH
     * 1、获取订单order；
     * 2、实例化nft合约；
     * 3、将NFT转给买家；
     * 4、将ETH转给卖家，多余ETH给买家退款；
     * 5、删除order
     * 6、释放购买事件
     */
    function purchase(address _nftAddr, uint256 _tokenId) public payable {
        // 获取订单order
        Order storage _order = nftList[_nftAddr][_tokenId];
        require(_order.price > 0, "Invalid Price"); // NFT价格大于0
        require(msg.value >= _order.price, "Increase price"); // 购买价格大于标价

        // 实例化nft合约
        IERC721 _nft = IERC721(_nftAddr);
        require(_nft.ownerOf(_tokenId) == address(this), "Invalid Order"); // NFT在合约中

        // 将NFT转给买家
        _nft.safeTransferFrom(address(this), msg.sender, _tokenId);

        // 将ETH转给卖家，多余ETH给买家退款
        payable(_order.owner).transfer(_order.price);
        payable(msg.sender).transfer(msg.value - _order.price);

        // 删除order
        delete nftList[_nftAddr][_tokenId];

        // 释放购买事件
        emit Purchase(msg.sender, _nftAddr, _tokenId, _order.price);
    }

    /**
     * @dev 撤单： 卖家取消挂单
     * 1、获取订单order；
     * 2、实例化nft合约；
     * 3、将NFT转给买家；
     * 4、删除order
     * 5、释放撤单事件
     */

    function revoke(address _nftAddr, uint256 _tokenId) public {
        // 获取订单order
        Order storage _order = nftList[_nftAddr][_tokenId];
        require(_order.owner == msg.sender, "Not Owner"); // 必须由持有人发起

        // 实例化nft合约
        IERC721 _nft = IERC721(_nftAddr);
        require(_nft.ownerOf(_tokenId) == address(this), "Invalid Order"); // NFT在合约中

        // 将NFT转给卖家
        _nft.safeTransferFrom(address(this), msg.sender, _tokenId);

        // 删除order
        delete nftList[_nftAddr][_tokenId];

        // 释放撤单事件
        emit Revoke(msg.sender, _nftAddr, _tokenId);
    }

    /**
     * @dev 调整价格: 卖家调整挂单价格
     * 1、获取订单order；
     * 2、实例化nft合约；
     * 3、调整NFT价格；
     * 4、释放调整价格事件
     */
    function update(
        address _nftAddr,
        uint256 _tokenId,
        uint256 _newPrice
    ) public {
        require(_newPrice > 0, "Invalid Price"); // NFT价格大于0
        // 获取订单order
        Order storage _order = nftList[_nftAddr][_tokenId];
        require(_order.owner == msg.sender, "Not Owner"); // 必须由持有人发起

        // 实例化nft合约
        IERC721 _nft = IERC721(_nftAddr);
        require(_nft.ownerOf(_tokenId) == address(this), "Invalid Order"); // NFT在合约中

        // 调整NFT价格
        _order.price = _newPrice;

        // 释放调整价格事件
        emit Update(msg.sender, _nftAddr, _tokenId, _newPrice);
    }

    // 实现{IERC721Receiver}的onERC721Received，能够接收ERC721代币
    function onERC721Received(
        address operator,
        address from,
        uint tokenId,
        bytes calldata data
    ) external pure override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
}
