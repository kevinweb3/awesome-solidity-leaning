// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev 链上随机数生成，由solidity的 keccak256() 哈希函数来获取伪随机数, 最便捷的链上随机数生成方法
 * @notice 这个方法并不安全, `block.timestamp`，`msg.sender`和`blockhash(block.number-1)`这些变量都是公开的，使用者可以预测出用这些种子生成出的随机数，并挑出他们想要的随机数执行合约, 容易受到攻击
 */
contract RandomOnchain {
    function getRandomOnchain() public view returns (uint256) {
        // remix运行blockhash会报错
        bytes32 randomBytes = keccak256(
            abi.encodePacked(
                block.timestamp,
                msg.sender,
                blockhash(block.number - 1)
            )
        );

        return uint256(randomBytes);
    }
}
