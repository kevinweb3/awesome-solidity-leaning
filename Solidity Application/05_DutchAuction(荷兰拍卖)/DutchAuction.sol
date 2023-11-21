// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721.sol";

/**
 * 1、荷兰拍卖原理：荷兰拍卖（`Dutch Auction`）是一种特殊的拍卖形式。 亦称“减价拍卖”，它是指拍卖标的的竞价由高到低依次递减直到第一个竞买人应价（达到或超过底价）时击槌成交的一种拍卖。在币圈，很多`NFT`通过荷兰拍卖发售，其中包括`Azuki`和`World of Women`，其中`Azuki`通过荷兰拍卖筹集了超过`8000`枚`ETH`。
 *
 * 2、项目背景：荷兰拍卖的价格由最高慢慢下降，能让项目方获得最大的收入。拍卖持续较长时间（通常6小时以上），可以避免`gas war`；
 *
 * 3、荷兰拍卖合约解析：
 * 合约中一共有9个状态变量，其中有6个和拍卖相关，他们是：
 * COLLECTOIN_SIZE：NFT总量。
 * AUCTION_START_PRICE：荷兰拍卖起拍价，也是最高价。
 * AUCTION_END_PRICE：荷兰拍卖结束价，也是最低价/地板价。
 * AUCTION_TIME：拍卖持续时长。
 * AUCTION_DROP_INTERVAL：每过多久时间，价格衰减一次。
 * auctionStartTime：拍卖起始时间（区块链时间戳，block.timestamp）。
 */

contract DuthAuction is Ownable, ERC721 {
    uint256 public constant COLLECTOIN_SIZE = 10000; // NFT总数
    uint256 public constant AUCTION_START_PRICE = 1 ether; // 起拍价
    uint256 public constant AUCTION_END_PRICE = 0.1 ether; // 结束价（最低价）
    uint256 public constant AUCTION_TIME = 10 minutes; // 拍卖时间，为了测试方便设为10分钟
    uint256 public constant AUCTION_DROP_INTERVAL = 1 minutes; // 每过多久时间，价格衰减一次
    uint256 public constant AUCTION_DROP_PER_STEP =
        (AUCTION_START_PRICE - AUCTION_END_PRICE) /
            (AUCTION_TIME / AUCTION_DROP_INTERVAL); // 每次价格衰减步长

    uint256 public auctionsStartTime; // 拍卖开始时间戳
    string private _baseTokenURI; // metadata URI
    uint256[] private _allTokens; // 记录所有存在的tokenId

    constructor() ERC721("Dutch Auctoin", "Dutch Auctoin") {
        auctionsStartTime = block.timestamp;
    }

    // ERC721Enumerable中totalSupply函数的实现
    function totalSupply() public view virtual returns (uint256) {
        return _allTokens.length;
    }

    // Private函数，在_allTokens中添加一个新的token
    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
        _allTokens.push(tokenId);
    }

    // 拍卖函数mint
    function auctionMint(uint256 quantity) external payable {
        uint256 _saleStarTime = uint256(auctionsStartTime); // 建立local变量，减少gas花费
        // 检查是否设置起拍时间，拍卖是否开始
        require(
            _saleStartTime != 0 && block.timestamp >= _saleStartTime,
            "sale has not started yet"
        );
        // 检查是否超过NFT上限
        require(
            totalSupply() + quantity <= COLLECTOIN_SIZE,
            "not enough remaining reserved for auction to support desired mint amount"
        );

        // 计算mint成本
        uint256 totalCost = getAuctionPrice() * quantity;

        // 检查用户是否支付足够ETH
        require(msg.value >= totalCost, "Need to send more ETH.");

        // Mint NFT
        for (uint256 i = 0; i < quantity; i++) {
            uint256 mintIndex = totalSupply();
            _mint(msg.sender, mintIndex);
            _addTokenToAllTokensEnumeration(mintIndex);
        }

        // 多余ETH退款
        if (msg.value < totalCost) {
            payable(msg.sender).transfer(msg.value - totalCost);
        }
    }

    // 拍卖实时价格
    function getAuctionPrice() public view returns (uint256) {
        if (block.timestamp < auctionStartTime) {
            return AUCTION_START_PRICE;
        } else if (block.timestamp - auctionStartTime >= AUCTION_TIME) {
            return AUCTION_END_PRICE;
        } else {
            uint256 steps = (block.timestamp - auctionStartTime) /
                AUCTION_DROP_INTERVAL;
            return AUCTION_START_PRICE - (steps * AUCTION_DROP_PER_STEP);
        }
    }

    // auctionStartTime setter函数，onlyOwner
    function setAuctionStartTime(uint32 timestamp) external onlyOwner {
        auctionStartTime = timestamp;
    }

    // BaseURI
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    // BaseURI setter函数, onlyOwner
    function setBaseURI(string calldata baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }

    // 提款函数，onlyOwner
    function withdrawMoney() external onlyOwner {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "withdraw failed");
    }
}
