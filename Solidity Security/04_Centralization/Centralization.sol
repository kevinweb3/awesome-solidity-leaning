// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev 有中心化风险的合约多种多样，这里只举一个最常见的例子：`owner`地址可以任意铸造代币的`ERC20`合约。当项目内鬼或黑客取得`owner`的私钥后，可以无限铸币，造成投资人大量损失。
 */

import "../../openzeppelin/token/ERC20/ERC20.sol";
import "../../openzeppelin/access/Ownable.sol";

contract Centralization is ERC20, Ownable {
    constructor() ERC20("Centralization", "Cent") {
        address exposedAccount = 0xe16C1623c1AA7D919cd2241d8b36d9E79C1Be2A2;
        transferOwnership(exposedAccount);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}
