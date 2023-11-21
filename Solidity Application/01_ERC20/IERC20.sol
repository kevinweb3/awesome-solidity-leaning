// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// ERC20接口合约, ERC20的标准接口，2个事件（转账和授权），6个函数（代币总供给、账户代币余额、转账触发、授权转账、返回授权额度、授权触发）

interface IERC20 {
    // 释放条件：当 `value` 单位的货币从账户 (`from`) 转账到另一账户 (`to`)时.
    event Trancefer(address indexed from, address indexed to, uint256 amount);

    // 释放条件：当 `value` 单位的货币从账户 (`owner`) 授权给另一账户 (`spender`)时.
    event Approve(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    // 返回代币总供给
    function totalSupply() external view returns (uint256);

    // 返回账户`account`所持有的代币数
    function balanceOf(address account) external view returns (uint256);

    // 转账 `amount` 单位代币，从调用者账户到另一账户 `to`. 如果成功，返回 `true`. 释放 {Transfer} 事件.
    // 转账事件
    function transfer(address to, uint256 amount) external returns (bool);

    // 返回`owner`账户授权给`spender`账户的额度，默认为0。当{approve} 或 {transferFrom} 被调用时，`allowance`会改变. 返回授权额度
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    // 调用者账户给`spender`账户授权 `amount`数量代币。如果成功，返回 `true`.释放 {Approval} 事件.
    // 授权事件
    function approve(address spender, uint256 amount) external returns (bool);

    // 通过授权机制，从`from`账户向`to`账户转账`amount`数量代币。转账的部分会从调用者的`allowance`中扣除。如果成功，返回 `true`. 释放 {Transfer} 事件.
    // 授权转账
    function transferFrom(
        address from,
        address to,
        uint amount
    ) external returns (bool);
}
