// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// 空投合约

import "./IERC20.sol";

// ERC20代币合约
/**
 * 1、在合约部署的时候实现合约名称和符号初始化
 * 2、实现了5个函数（代币转账、代币授权、代币授权转账、铸造代币、销毁代币）
 */
contract ERC20 is IERC20 {
    mapping(address => uint256) public override balanceOf;

    mapping(address => mapping(address => uint256)) public override allowance;

    uint256 public override totalSupply;

    string public name;

    string public symbol;

    uint8 public decimals = 18;

    // @dev 在合约部署的时候实现合约名称和符号
    constructor(string memory name_, string memory symbol_) {
        name = name_;
        symbol = symbol_;
    }

    // @dev 实现`transfer`函数，代币转账逻辑
    function transfer(
        address recipient,
        uint256 amount
    ) external override returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Trancefer(msg.sender, recipient, amount);
        return true;
    }

    // @dev 实现 `approve` 函数, 代币授权逻辑
    function approve(
        address spender,
        uint256 amount
    ) external override returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approve(msg.sender, spender, amount);
        return true;
    }

    // @dev 实现`transferFrom`函数，代币授权转账逻辑
    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external override returns (bool) {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Trancefer(sender, recipient, amount);
        return true;
    }

    // @dev 铸造代币，从 `0` 地址转账给 调用者地址
    function mint(uint amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Trancefer(address(0), msg.sender, amount);
    }

    // @dev 销毁代币，从 调用者地址 转账给  `0` 地址
    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Trancefer(msg.sender, address(0), amount);
    }
}

/**
 * @notice 空投合约实现逻辑：项目发展种子用户时直接批量向多个种子用户转账ERC20代币，使用前需要先授权
 *
 */
contract Airdrop {
    mapping(address => uint) failTransferList;

    // 向多个地址转账ERC20代币
    function multiTransferToken(
        address _tokenAddress, // 转账合约ERC代币地址
        address[] calldata _addresses, // 空投用户地址数组
        uint256[] calldata _amounts // 代币数量数组（对应每个空投地址的代币数量）
    ) external {
        // 检查：_addresses和_amounts数组的长度相等
        require(_addresses.length == _amounts.length, "aaaaaaaaaa");
        IERC20 token = IERC20(_tokenAddress); // 获取ERC20代币合约对象
        uint _tokenSum = getSum(_amounts); // 计算需要空投的代币数量总量
        // 检查：授权代币数量 > 空投代币总量
        require(
            token.allowance(msg.sender, address(this)) > _tokenSum,
            "aaaaaaaaaa"
        );

        // 进行空投，进行批量ERC20代币转账，for循环，利用transferFrom发送空投
        for (uint i = 0; i < _addresses.length; i++) {
            token.transferFrom(msg.sender, _addresses[i], _amounts[i]);
        }
    }

    // 向多个地址转账ETH
    function multiTransferETH(
        address payable[] calldata _addresses,
        uint256[] calldata _amounts
    ) public payable {
        // 检查：_addresses和_amounts数组的长度相等
        require(_addresses.length == _amounts.length, "aaaaaaaaaa");
        uint _tokenSum = getSum(_amounts); // 计算需要空投的代币数量总量
        require(msg.value == _tokenSum, "Transfer amount error");
        // for循环，利用transfer函数发送ETH
        for (uint i = 0; i < _addresses.length; i++) {
            // _addresses[i].transfer(_amounts[i]);  注释代码有Dos攻击风险, 并且transfer 也是不推荐写法
            (bool success, ) = _addresses[i].call{value: _amounts[i]}("");
            if (!success) {
                failTransferList[_addresses[i]] = _amounts[i];
            }
        }
    }

    // 给空投失败提供主动操作机会
    function withdrawFromFailList(address _to) public {
        uint failAmount = failTransferList[msg.sender];
        require(failAmount > 0, "You are not in failed list");
        (bool success, ) = _to.call{value: failAmount}("");
        require(success, "Fail withdraw");
    }

    function getSum(uint256[] calldata _arr) public pure returns (uint sum) {
        for (uint i = 0; i < _arr.length; i++) sum = sum + _arr[i];
    }
}
