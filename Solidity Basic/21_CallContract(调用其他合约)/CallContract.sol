// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// 调用其他合约
contract OtherContract {
    uint256 private _x = 0;

    // 收到eth事件，记录amount和gas
    event Log(uint amount, uint gas);

    // 返回合约ETH余额
    function getBalance() public view returns (uint) {
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
    function getX() external view returns (uint x) {
        x = _x;
    }
}

contract CallContract {
    function callSetX(address _Address, uint256 x) external {
        OtherContract(_Address).setX(x);
    }

    function callGetX(OtherContract _Address) external view returns (uint x) {
        x = _Address.getX();
    }

    function callGetX2(OtherContract _Address) external view returns (uint x) {
        OtherContract oc = OtherContract(_Address);
        x = oc.getX();
    }

    function setTransferETH(address otherContract, uint256 x) external payable {
        OtherContract(otherContract).setX{value: msg.value}(x);
    }
}

/*
    调用已部署合约:
    在Solidity中，一个合约可以调用另一个合约的函数，这在构建复杂的DApps时非常有用

    调用OtherContract合约:
    我们可以利用合约的地址和合约代码（或接口）来创建合约的引用：_Name(_Address)，其中_Name是合约名，应与合约代码（或接口）中标注的合约名保持一致，_Address是合约地址。然后用合约的引用来调用它的函数：_Name(_Address).f()，其中f()是要调用的函数。

    1. 传入合约地址
    我们可以在函数里传入目标合约地址，生成目标合约的引用，然后调用目标函数。以调用OtherContract合约的setX函数为例，我们在新合约中写一个callSetX函数，传入已部署好的OtherContract合约地址_Address和setX的参数x：

    2. 传入合约变量
    我们可以直接在函数里传入合约的引用，只需要把上面参数的address类型改为目标合约名，比如OtherContract。下面例子实现了调用目标合约的getX()函数。

    3. 创建合约变量
我们可以创建合约变量，然后通过它来调用目标函数。下面例子，我们给变量oc存储了OtherContract合约的引用：

    4. 调用合约并发送ETH
如果目标合约的函数是payable的，那么我们可以通过调用它来给合约转账：_Name(_Address).f{value: _Value}()，其中_Name是合约名，_Address是合约地址，f是目标函数名，_Value是要转的ETH数额（以wei为单位）。

*/
