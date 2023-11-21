// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.4;

contract Fallback {
    /* 触发fallback() 还是 receive()?
           接收ETH
              |
         msg.data是空？
            /  \
          是    否
          /      \
receive()存在?   fallback()
        / \
       是  否
      /     \
receive()  fallback   
    */

   // 定义事件
    event receivedCalled(address Sender, uint Value);
    event fallBackCalled(address Sender, uint Value, bytes Data);

    // 接收ETH时释放Received事件
    receive() external payable {
        emit receivedCalled(msg.sender, msg.value);
    }

    // fallback
    fallback() external payable {
        emit fallBackCalled(msg.sender, msg.value, msg.data);
    }
}

/*
    Solidity支持两种特殊的回调函数，receive()和fallback()，他们主要在两种情况下被使用：
    接收ETH
    处理合约中不存在的函数调用（代理合约proxy contract）

    接收ETH函数 receive:
    receive()函数是在合约收到ETH转账时被调用的函数。一个合约最多有一个receive()函数，声明方式与一般函数不一样，不需要function关键字：receive() external payable { ... }。receive()函数不能有任何的参数，不能返回任何值，必须包含external和payable。

    当合约接收ETH的时候，receive()会被触发。receive()最好不要执行太多的逻辑因为如果别人用send和transfer方法发送ETH的话，gas会限制在2300，receive()太复杂可能会触发Out of Gas报错；如果用call就可以自定义gas执行更复杂的逻辑（这三种发送ETH的方法我们之后会讲到）。

    回退函数 fallback:
    fallback()函数会在调用合约不存在的函数时被触发。可用于接收ETH，也可以用于代理合约proxy contract。fallback()声明时不需要function关键字，必须由external修饰，一般也会用payable修饰，用于接收ETH:fallback() external payable { ... }。

    receive和fallback的区别:
    简单来说，合约接收ETH时，msg.data为空且存在receive()时，会触发receive()；msg.data不为空或不存在receive()时，会触发fallback()，此时fallback()必须为payable。

    receive()和payable fallback()均不存在的时候，向合约直接发送ETH将会报错（你仍可以通过带有payable的函数向合约发送ETH）。

*/