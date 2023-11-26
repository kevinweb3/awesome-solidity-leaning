// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../openzeppelin/token/ERC20/ERC20.sol";

/**
 * @dev 过程解析
 * 1、Alice 从 AliceCoin 获得100个token（ERC20 Token）
 * 2、Bob 从 BobCoin 获得100个token（ERC20 Token）
 * 3、Alice 和 Bob 交易Token，从 BobCoin 账上 转账交易 10个 AliceCoin 兑换 20个 BobCoin
 * 4、Alice 和 Bob 分别将自己的 Token 部署在 Token Swap上
 * 5、Alice 授权 TokenSwap 提现 10个 tokens 从 AliceCoin 上
 * 6、Bob 授权 TokenSwap 提现 20个 tokens 从 BobCoin 上
 * 7、Alice 和 Bob 发起交易 TokenSwap.swap()
 * 8、Alice 和 Bob 交易成功
 */

contract TokenSwap {
    IERC20 public token1;
    address public owner1;
    uint public amount1;

    IERC20 public token2;
    address public owner2;
    uint public amount2;

    constructor(
        address _token1,
        address _owner1,
        uint _amount1,
        address _token2,
        address _owner2,
        uint _amount2
    ) {
        token1 = IERC20(_token1);
        owner1 = _owner1;
        amount1 = _amount1;
        token2 = IERC20(_token1);
        owner2 = _owner2;
        amount2 = _amount2;
    }

    function swap() public {
        // 判断owner执行者
        require(msg.sender == owner1 || msg.sender == owner2, "Not authorized");
        // 判断账户余额，要大于或等于转账金额
        require(
            token1.allowance(owner1, address(this)) >= amount1,
            "Token 1 allowance too low"
        );
        // 判断账户余额，要大于或等于转账金额
        require(
            token2.allowance(owner2, address(this)) >= amount2,
            "Token 2 allowance too low"
        );
        _safeTransferFrom(token1, owner1, owner2, amount1);
        _safeTransferFrom(token2, owner2, owner1, amount2);
    }

    // 合约内部转账函数，private
    function _safeTransferFrom(
        IERC20 token,
        address sender,
        address recipient,
        uint amount
    ) private {
        // 调用IERC20 transferFrom 转账
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent, "Token transfer failed");
    }
}
