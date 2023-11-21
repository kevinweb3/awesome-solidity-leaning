// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.4;

contract Pair {
    address public factory; // 工厂合约地址
    address public token0; // 代币1
    address public token1; // 代币2

    constructor() payable {
        factory = msg.sender;
    }

    function initialize(address _token0, address _token1) external {
        require(msg.sender == factory, 'UniswapV2: FORBIDDEN');
        token0 = _token0;
        token1 = _token1;
    }
}

contract PairFactory {
    // 通过两个代币地址查Pair地址
    mapping (address => mapping (address => address)) public getPair;
    address[] public allPairs; // 保存所有Pair地址

    function createPair(address tokenA, address tokenB) external returns (address pairAddr) {
        Pair pair = new Pair(); // 创建新合约
        pair.initialize(tokenA, tokenB); // 调用新合约的initialize方法

        // 更新地址map
        pairAddr = address(pair);
        allPairs.push(pairAddr);
        getPair[tokenA][tokenB] = pairAddr;
        getPair[tokenB][tokenA] = pairAddr;
    }
}


/*
    在以太坊链上，用户（外部账户，EOA）可以创建智能合约，智能合约同样也可以创建新的智能合约。去中心化交易所uniswap就是利用工厂合约（PairFactory）创建了无数个币对合约（Pair）。这一讲，我会用简化版的uniswap讲如何通过合约创建合约。

    create
    有两种方法可以在合约中创建新合约，create和create2，这里我们讲create，下一讲会介绍create2。
    create的用法很简单，就是new一个合约，并传入新合约构造函数所需的参数：
    Contract x = new Contract{value: _value}(params)
    其中Contract是要创建的合约名，x是合约对象（地址），如果构造函数是payable，可以创建时转入_value数量的ETH，params是新合约构造函数的参数。


    极简Uniswap
    Uniswap V2核心合约中包含两个合约：
    UniswapV2Pair: 币对合约，用于管理币对地址、流动性、买卖。
    UniswapV2Factory: 工厂合约，用于创建新的币对，并管理币对地址。
    下面我们用create方法实现一个极简版的Uniswap：Pair币对合约负责管理币对地址，PairFactory工厂合约用于创建新的币对，并管理币对地址。

    Pair合约
    Pair合约很简单，包含3个状态变量：factory，token0和token1。
    构造函数constructor在部署时将factory赋值为工厂合约地址。initialize函数会由工厂合约在部署完成后手动调用以初始化代币地址，将token0和token1更新为币对中两种代币的地址。

    PairFactory
    工厂合约（PairFactory）有两个状态变量getPair是两个代币地址到币对地址的map，方便根据代币找到币对地址；allPairs是币对地址的数组，存储了所有代币地址。
    PairFactory合约只有一个createPair函数，根据输入的两个代币地址tokenA和tokenB来创建新的Pair合约。

*/