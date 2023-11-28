// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

/**
 * @dev 选择器碰撞
 */

// 被攻击合约案例
contract SelectorClash {
    bool public solved; // 攻击是否成功

    function putCurEpochConPubKeyBytes(bytes memory _bytes) public {
        require(msg.sender == address(this), "Not Owner");
        solved = true;
    }

    function executeCrossChainTx(
        bytes memory _method,
        bytes memory _bytes
    ) public returns (bool success) {
        (success, ) = address(this).call(
            abi.encodePacked(
                bytes4(
                    keccak256(abi.encodePacked(_method, "(bytes,bytes,uint64)"))
                ),
                abi.encode(_bytes)
            )
        );
    }

    function secretSlector() external pure returns (bytes4) {
        return bytes4(keccak256("putCurEpochConPubKeyBytes(bytes)"));
    }

    function hackSlector() external pure returns (bytes4) {
        return bytes4(keccak256("f1121318093(bytes,bytes,uint64)"));
    }
}

/**
 * @dev 攻击方法: 利用`executeCrossChainTx()`函数调用合约中的`putCurEpochConPubKeyBytes()`，目标函数的选择器为：`0x41973cd9`。观察到`executeCrossChainTx()`中是利用`_method`参数和`"(bytes,bytes,uint64)"`作为函数签名计算的选择器。因此，我们只需要选择恰当的`_method`，让这里算出的选择器等于`0x41973cd9`，通过选择器碰撞调用目标函数。
 */
