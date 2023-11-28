// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// ERC20 interface.
interface IERC20 {
    function balanceOf(address owner) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transfer(address to, uint256 amount) external returns (bool);
}

// WETH interfaec.
interface IWETH is IERC20 {
    function deposit() external payable;
}

// 将其 ERC20 余额换成另一个 ERC20 的演示合约.
contract SimpleTokenSwap {
    event BoughtTokens(IERC20 sellToken, IERC20 buyToken, uint256 boughtAmount);

    // WETH 合约.
    IWETH public immutable WETH;
    address public owner;
    // 0x 代理交换地址.
    address public exchangeProxy;

    constructor(IWETH _weth, address _exchangeProxy) {
        WETH = _weth;
        exchangeProxy = _exchangeProxy;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "ONLY_OWNER");
        _;
    }

    // 应付回退，以允许此合约接收协议费用退款.
    receive() external payable {}

    // 将此 contrat 持有的代币转移给发送者/所有者.
    function withdrawToken(IERC20 token, uint256 amount) external onlyOwner {
        require(token.transfer(msg.sender, amount));
    }

    // 将该交易对象持有的 ETH 转移给发送者/所有者.
    function withdrawETH(uint256 amount) external onlyOwner {
        payable(msg.sender).transfer(amount);
    }

    // 将 ETH 转入该合约并包装成 WETH.
    function depositETH() external payable {
        WETH.deposit{value: msg.value}();
    }

    // 使用 0x-API 报价交换本合约持有的 ERC20->ERC20 代币.
    function fillQuote(
        IERC20 sellToken,
        IERC20 buyToken,
        address spender,
        address payable swapTarget,
        bytes calldata swapCallData
    )
        external
        payable
        onlyOwner // Must attach ETH equal to the `value` field from the API response.
    {
        // 检查 swapTarget 是否实际上是 0x ExchangeProxy 的地址
        require(swapTarget == exchangeProxy, "Target not ExchangeProxy");

        // 跟踪我们的buyToken余额，以确定我们购买了多少
        uint256 boughtAmount = buyToken.balanceOf(address(this));

        // Give `spender` an infinite allowance to spend this contract's `sellToken`.
        // Note that for some tokens (e.g., USDT, KNC), you must first reset any existing
        // allowance to 0 before being able to update it.
        require(sellToken.approve(spender, type(uint256).max));
        // Call the encoded swap function call on the contract at `swapTarget`,
        // passing along any ETH attached to this function call to cover protocol fees.
        (bool success, ) = swapTarget.call{value: msg.value}(swapCallData);
        require(success, "SWAP_CALL_FAILED");
        // Refund any unspent protocol fees to the sender.
        payable(msg.sender).transfer(address(this).balance);

        // Use our current buyToken balance to determine how much we've bought.
        boughtAmount = buyToken.balanceOf(address(this)) - boughtAmount;
        emit BoughtTokens(sellToken, buyToken, boughtAmount);
    }
}
