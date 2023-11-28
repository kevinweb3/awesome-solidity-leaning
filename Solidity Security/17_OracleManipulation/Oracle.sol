// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../../openzeppelin/token/ERC20/IERC20.sol";
import "../../openzeppelin/token/ERC20/ERC20.sol";

/**
 * @dev 操纵预言机
 * 最常用的就是价格预言机（price oracle），它可以指代任何可以让你查询币价的数据源。典型用例：
 * 1、去中心借贷平台（AAVE）使用它来确定借款人是否已达到清算阈值。
 * 2、合成资产平台（Synthetix）使用它来确定资产最新价格，并支持 0 滑点交易。
 * 3、MakerDAO使用它来确定抵押品的价格，并铸造相应的稳定币 $DAI。
 */

// `oUSD` 合约。该合约是一个稳定币合约，符合ERC20标准。类似合成资产平台Synthetix，用户可以在这个合约中零滑点的将 `ETH` 兑换为 `oUSD`（Oracle USD）。兑换价格由自定义的价格预言机（`getPrice()`函数）决定，这里采取的是Uniswap V2的 `WETH-BUSD` 的瞬时价格。在之后的攻击示例中，我们会看到这个预言机在使用闪电贷和大额资金的情况下非常容易被操纵
contract oUSD is ERC20 {
    // 主网合约
    address public constant FACTORY_V2 =
        0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant BUSD = 0x4Fabb145d64652a948d72533023f6E7A623C7C53;

    IUniswapV2Factory public factory = IUniswapV2Factory(FACTORY_V2);
    IUniswapV2Pair public pair = IUniswapV2Pair(factory.getPair(WETH, BUSD));
    IERC20 public weth = IERC20(WETH);
    IERC20 public busd = IERC20(BUSD);

    constructor() ERC20("Oracle USD", "oUSD") {}

    // 获取ETH price
    function getPrice() public view returns (uint256 price) {
        // pair 交易对中储备
        (uint112 reserve0, uint112 reserve1, ) = pair.getReserves();
        // ETH 瞬时价格
        price = reserve0 / reserve1;
    }

    function swap() external payable returns (uint256 amount) {
        // 获取价格
        uint price = getPrice();
        // 计算兑换数量
        amount = price * msg.value;
        // 铸造代币
        _mint(msg.sender, amount);
    }
}

interface IUniswapV2Factory {
    function getPair(
        address tokenA,
        address tokenB
    ) external view returns (address pair);
}

interface IUniswapV2Pair {
    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function price0CumulativeLast() external view returns (uint);

    function price1CumulativeLast() external view returns (uint);

    function totalSupply() external view returns (uint);

    function balanceOf(address owner) external view returns (uint);
}

interface IUniswapV2Router {
    //  swap相关
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    //  流动性相关
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);

    function factory() external view returns (address);
}
