# 0x协议
0x 协议是一个面向以太坊的、开源的去中心化交易协议，该协议旨在作为开放标准和通用构建模块，让开发者可以将其作为底层协议来搭建 DEX 或是有交易功能的 DApp，并聚合这些 DApp 中的流动性。除此之外，0x 协议目前还可以通过 0x API 聚合 Uniswap、Curve 等其他 DEX 协议的流动性。

Website：https://0x.org/

Twitter：https://twitter.com/0xproject

Forum：https://forum.0x.org/

Docs：https://0x.org/docs

Medium：https://blog.0xproject.com/

Github：https://github.com/0xProject

##  原理介绍
 在0x系统中，有maker和taker两个角色。
 maker创建订单，并提供流动性，且可以聚合流动性：
- On-chain liquidity - DEXs, AMMs (e.g. Uniswap, Curve, Bancor)
- Off-chain liquidity - Professional Market Makers, 0x's Open Orderbook network
  taker负责吃单，消费流动性

  ### 0xAPI
  0x API是允许DeFi开发人员利用0x协议和交易ERC20资产的接口
  主要有/swap和 /orderbook 接口：
  - swap  聚合链上和链下流动性，smart order routing 可以在去中心化交易所之间拆单，保证最小滑点。
  - orderbook 查询0x开放订单的流动性，以及现价单。

  ### 工作原理
  链下中继 链上结算
  1. Maker 创建一个 0x 订单，这是一个遵循标准订单消息格式的 json 对象
  2. 对订单进行哈希处理，Maker 对订单进行签名，以加密方式提交他们创作的订单。
  3. 订单与交易对手共享。
    - 如果 0x 订单的制造商已经知道他们想要的交易对手，他们可以直接发送订单（通过电子邮件、聊天或场外交易平台）
    - 如果制造商不知道愿意接受交易的交易对手，他们可以将订单提交到订单簿。
  4. 0x API 聚合所有来源的流动性，以向接受者提供订单的最佳价格。
  5. 接受者通过向区块链提交订单和他们将执行的金额来执行 0x 订单。
  6. 0x协议的结算逻辑验证了Maker的数字签名，以及交易的所有条件是否得到满足。