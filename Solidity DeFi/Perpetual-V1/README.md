# Perpetual V1

## 期货原理

### 期货

一般来说，获得某种资产风险敞口最简单的方式，便是购买并持有这种产品的现货。但是直接持有现货却有两个固有缺陷:

1. 现货往往还有储藏、运输等附加成本；
2. 是资金效率着实不高（无法加杠杆），为了持有一单位的风险敞口，投资者必须使用等量的资金购买现货。

### 期货合约

因此，在经过数百年的发展后，人们逐渐摸索出了一种可以脱离现货，直接通过衍生品对现货风险敞口进行管理的新方式。这便是期货合约，以及配套的保证金交易制度。
**期货合约想要达到的目的，便是使投资者能够在不持有现货的同时，对现货的风险敞口进行交易和管理**

在交割日当天，买卖期货便完全等价于买卖现货，因此交割日当天的期货价格与现货价格必然相等。
期货合约维持与现货价格锚定的核心，便是实物交割机制。

缺点:

1. 期现套利所占用资金的成本，会同时影响期货的价格
2. 实物交割导致了流动性割裂
3. 实物交割可能诱发对市场的操纵活动

## 永续合约

永续合约由期货合约发展而来（永续期货合约），永续合约的目标函数（y = x）与期货合约完全相同，其与期货产品唯一的差别，便是采用了全新的价格锚定机制。

永续合约便是彻底摒弃了实物交割机制，改为通过支付**资金费的方式**锚定目标价格，达到合约价格与现货价格的绑定。

永续合约采用的锚定机制可以简化为以下三步：
第一，由外部输入一个明确的目标价格 x（一般采用其他现货市场的现货成交价格）。

第二，通过永续合约自己独立的保证金交易市场（订单簿式或 AMM），通过自由交易产生一个独立于目标价格 x 的合约价格 y。

第三，添加一套激励与惩罚机制，如果合约价格 y 高于目标价格 x，便惩罚合约市场中的多头头寸，并将罚金作为奖励支付给持有空头头寸的用户，且价格偏离程度越大惩罚金额就越高。

**这种由偏离目标价格一方向维持目标价格一方支付罚金的模式，便是我们一开始提到的永续合约的资金费制度**。通过这种奖惩措施，永续合约的设计者促使合约市场中价格偏离的一方进行调整，最终使得合约价格与目标价格趋同。从近几年的实际应用结果来看，这种新的锚定机制极好的保证了永续合约与目标价格的锚定。

特点：

1. 统一了市场的流动性
2. 同样采用保证金制度，交易体验与传统期货相近
3. 永续合约减弱了无风险利率的影响，更好地反应目标价格
4. 创建永续合约不必再依赖于现货市场

**资金费率**和**清算率**是永续协议的关键环节

### 资金费率

**资金费率**和**清算率**是永续协议的关键环节。

**资金费用**机制是永续合约最主要的特点，它可以让永续合约**始终锚定现货价格。**

```math
资金费用 = 净仓位价值 × 资金费率
```

- 资金费率是正数，永续合约价格高于标记价格。因此，多方要支付资金费用给空方；
- 资金费率是负数，永续合约价格低于标记价格。因此，空方要支付资金费用给多方。
  资金费率是指基于永续合约市场价格与现货价格之间的价差。它可防止两个市场的价格持续出现偏差，它会在一天之内多次重新计算，部分合约交易平台每隔八个小时计算一次。

资金费率由两部分组成：利率和溢价因子。 此费率旨在确保永续掉期合约的交易价格紧跟现货价格。

永续掉期合约的价格相较于公平价格会有明显的溢价或折价。 在这种情况下，溢价指数将用于提高或降低下一个资金费率，使其符合目前掉期合约交易的水平。

每种掉期合约的溢价指数可参阅相关合约的明细页面，它的计算如下：

溢价指数 (P) = ( Max ( 0 , 深度加权买价 - 公平价格) - Max ( 0 , 公平价格 - 深度加权卖价)) / 现货价格 + 公平价格的合理基差

**最终资金费率的计算**:

资金费率 (F) = 溢价指数 (P) + clamp (利率 (I) - 溢价指数 (P), 0.05%, -0.05%)

资金费率限额：即对资金费率进行封顶以确保可以使用最高杠杆。 为了做到这一点，我们加上了两个限制：

1. 绝对的资金费率上限为 （起始保证金 - 维持保证金）的 75% 。 如果起始保证金为 1%，维持保证金为 0.5%，最大的资金率将为 75% \* (1%-0.5%) = 0.375%。

2. 资金费率在资金间隔区间不得变化大于维持保证金的 75％。

仓位价值与杠杆率无关。 例如，如果您持有 100 张 BTCUSD 合约，则将按照这些合约的名义价值收取或支付资金费用，而不是基于该仓位有多少保证金。

全仓模式下：资金费用收取时，将直接从用户的已实现盈亏上扣除，至多扣除至用户保证金率等于维持保证金率+平仓手续费率，多余部分不再收取。

逐仓模式下：资金费用收取时，将优先从用户的已实现盈亏上扣除，如果已实现盈亏不足，多余部分从用户持仓仓位的固定保证金上扣除，至多扣除至用户保证金率等于维持保证金率+平仓手续费率，多余部分不再收取。

PERP 资金利率按小时结算，而清算比率被设定为保证金的 6.25%。这意味着，持仓低于 6.25%保证金比例的交易者将面临被看守机器人清算的风险。机器人将获得清算保证金的 20%，而剩余部分将被送到协议的保险基金。

### 类型

永续合约分正向合约与反向合约：

**正向合约(U 本位合约)**，以 USDT 计算盈亏的合约。将 USDT 划转进合约账户开仓计算盈亏。  
**反向合约(币本位合约)**，以 BTC、ETH 等数字资产为标的计算盈亏的合约。如 BTC 反向合约，用户将 BTC 转入合约账户开仓，平仓后以 BTC 的形式获得盈利，或付出损失。


## 参考链接


- 期货原理: <https://www.theblockbeats.com/news/25619>
- perpetual: <https://zhuanlan.zhihu.com/p/395752324?utm_source=wechat_session&utm_medium=social&utm_oi=42064397991936&utm_campaign=shareopn>
- dehedge: <https://www.dhedge.org/>
- 官网文档: <https://docs.perp.fi/v/perpetual-protocol-jian-jie/>
- deri: <https://mp.weixin.qq.com/s/Lffxvqt2lXbfXbMyTP-84w>
- 永续合约: <https://zhuanlan.zhihu.com/p/354498449>
- 合约算法: <https://zhuanlan.zhihu.com/p/354337880>
- 合约算法: <https://www.zhihu.com/people/le-zhu-92-74>
- 技术解析永续衍生品合约的一般原理: https://www.beechain.net/news/29251.html
- deribit资金费率：https://legacy.deribit.com/pages/docs/perpetual
- 永续合约的资金费率介绍： https://medium.com/derivadex/funding-rates-under-the-hood-352e6be83ab