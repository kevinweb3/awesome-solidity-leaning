// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.4;

// 抽象合约
abstract contract Base {
    string public name = "Base";
    function getAlias() public pure virtual returns(string memory);
}

contract BaseImple is Base {
    function getAlias() public pure override returns(string memory) {
        return "BaseImple";
    }
}

/*
    抽象合约：
    如果一个智能合约里至少有一个未实现的函数，即某个函数缺少主体{}中的内容，则必须将该合约标为abstract，不然编译会报错；另外，未实现的函数需要加virtual，以便子合约重写。拿我们之前的插入排序合约为例，如果我们还没想好具体怎么实现插入排序函数，那么可以把合约标为abstract，之后让别人补写上。
*/