// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// 调用其他合约
contract OtherContract {
    uint256 private _x = 0;

    // 收到eth事件，记录amount和gas
    event Log(uint amount, uint gas);

    // 返回合约ETH余额
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    // 可以调整状态变量_x的函数，并且可以往合约转ETH (payable)
    function setX(uint256 x) external payable {
        _x = x;
        if (msg.value > 0) {
            emit Log(msg.value, gasleft());
        }
    }

    // 读取x
    function getX() external view returns(uint x) {
        x = _x;
    }
}

contract Call {
    event Response(bool success, bytes data);

    function callSetX(address payable _addr, uint256 x) public payable {
        (bool success, bytes memory data) = _addr.call{value: msg.value}(
            abi.encodeWithSignature("setX(uint256)", x)
        );

        emit Response(success, data);
    }

    function callGetX(address _addr) external returns(uint256) {
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("getX()")
        );

        emit Response(success, data);
        return abi.decode(data, (uint256));
    }

     function callNonExist(address _addr) external {
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("foo(uint256)")
        );

        emit Response(success, data);
    }
}

/*
    Call
    call 是address类型的低级成员函数，它用来与其他合约交互。它的返回值为(bool, data)，分别对应call是否成功以及目标函数的返回值。

    1、call是solidity官方推荐的通过触发fallback或receive函数发送ETH的方法。
    2、不推荐用call来调用另一个合约，因为当你调用不安全合约的函数时，你就把主动权交给了它。推荐的方法仍是声明合约变量后调用函数，见第21讲：调用其他合约
    3、当我们不知道对方合约的源代码或ABI，就没法生成合约变量；这时，我们仍可以通过call调用对方合约的函数。

    利用call调用目标合约
    1. Response事件

    我们写一个Call合约来调用目标合约函数。首先定义一个Response事件，输出call返回的success和data，方便我们观察返回值。

    2. 调用setX函数

    我们定义callSetX函数来调用目标合约的setX()，转入msg.value数额的ETH，并释放Response事件输出success和data：

    3. 调用getX函数

    下面我们调用getX()函数，它将返回目标合约_x的值，类型为uint256。我们可以利用abi.decode来解码call的返回值data，并读出数值。

    4. 调用不存在的函数

    如果我们给call输入的函数不存在于目标合约，那么目标合约的fallback函数会被触发。

*/