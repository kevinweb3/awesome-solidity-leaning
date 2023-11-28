// SPDX-License-Identifier: MIT
// By 0xAA
pragma solidity ^0.8.4;
import "../../openzeppelin/token/ERC721/ERC721.sol";

/**
 * @dev 操纵区块时间
 * 以太坊矿工可以操纵区块时间，如果抽奖合约的伪随机数依赖于区块时间，则可能被攻击。
 * 区块时间（block timestamp）是包含在以太坊区块头中的一个 `uint64` 值，代表此区块创建的 UTC 时间戳（单位：秒），在合并（The Merge）之前，以太坊会根据算力调整区块难度，因此出块时间不定，平均 14.5s 出一个区块，矿工可以操纵区块时间；合并之后，改为固定 12s 一个区块，验证节点不能操纵区块时间。
 */
contract TimeManipulation is ERC721 {
    uint256 totalSupply;

    // 构造函数，初始化NFT合集的名称、代号
    constructor() ERC721("", "") {}

    // 铸造函数：当区块时间能被7整除时才能mint成功
    function luckyMint() external returns (bool success) {
        if (block.timestamp % 170 == 0) {
            _mint(msg.sender, totalSupply); // mint
            totalSupply++;
            success = true;
        } else {
            success = false;
        }
    }
}

contract Roulette {
    uint public pastBlockTime;

    constructor() payable {}

    function spin() external payable {
        require(msg.value == 10 ether); // must send 10 ether to play
        require(block.timestamp != pastBlockTime); // only 1 transaction per block

        pastBlockTime = block.timestamp;

        if (block.timestamp % 15 == 0) {
            (bool sent, ) = msg.sender.call{value: address(this).balance}("");
            require(sent, "Failed to send Ether");
        }
    }
}
