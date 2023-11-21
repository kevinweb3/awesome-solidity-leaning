// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.4;

// 抽象合约和接口
abstract contract InsertionSort {
    funtion intertionSort(uint[] memory a) public pure virtual returns(uint[] memory);
}

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

interface IERRC721 is IERC165 {
     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    
    function balanceOf(address owner) external view returns (uint256 balance);

    function ownerOf(uint256 tokenId) external view returns (address owner);

    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    function transferFrom(address from, address to, uint256 tokenId) external;

    function approve(address to, uint256 tokenId) external;

    function getApproved(uint256 tokenId) external view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) external;

    function isApprovedForAll(address owner, address operator) external view returns (bool);

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
}

contract interactBAYC {
    // 利用BAYC地址创建接口合约变量（ETH主网）
    IERC721 BAYC = IERC721(0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D);

     // 通过接口调用BAYC的balanceOf()查询持仓量
    function balanceOfBAYC(address owner) external view returns (uint256 balance){
        return BAYC.balanceOf(owner);
    }

    // 通过接口调用BAYC的safeTransferFrom()安全转账
    function safeTransferFromBAYC(address from, address to, uint256 tokenId) external{
        BAYC.safeTransferFrom(from, to, tokenId);
    }
}

/*
    接口
    接口类似于抽象合约，但它不实现任何功能。接口的规则：

    1、不能包含状态变量
    2、不能包含构造函数
    3、不能继承除接口外的其他合约
    4、所有函数都必须是external且不能有函数体
    5、继承接口的非抽象合约必须实现接口定义的所有功能

    虽然接口不实现任何功能，但它非常重要。接口是智能合约的骨架，定义了合约的功能以及如何触发它们：如果智能合约实现了某种接口（比如ERC20或ERC721），其他Dapps和智能合约就知道如何与它交互。因为接口提供了两个重要的信息：

    合约里每个函数的bytes4选择器，以及函数签名函数名(每个参数类型）。

    接口id（更多信息见EIP165）

    另外，接口与合约ABI（Application Binary Interface）等价，可以相互转换：编译接口可以得到合约的ABI，利用abi-to-sol工具也可以将ABI json文件转换为接口sol文件。


    IERC721事件
    IERC721包含3个事件，其中Transfer和Approval事件在ERC20中也有。

    Transfer事件：在转账时被释放，记录代币的发出地址from，接收地址to和tokenid。
    Approval事件：在授权时释放，记录授权地址owner，被授权地址approved和tokenid。
    ApprovalForAll事件：在批量授权时释放，记录批量授权的发出地址owner，被授权地址operator和授权与否的approved。


    IERC721函数
    balanceOf：返回某地址的NFT持有量balance。
    ownerOf：返回某tokenId的主人owner。
    transferFrom：普通转账，参数为转出地址from，接收地址to和tokenId。
    safeTransferFrom：安全转账（如果接收方是合约地址，会要求实现ERC721Receiver接口）。参数为转出地址from，接收地址to和tokenId。
    approve：授权另一个地址使用你的NFT。参数为被授权地址approve和tokenId。
    getApproved：查询tokenId被批准给了哪个地址。
    setApprovalForAll：将自己持有的该系列NFT批量授权给某个地址operator。
    isApprovedForAll：查询某地址的NFT是否批量授权给了另一个operator地址。
    safeTransferFrom：安全转账的重载函数，参数里面包含了data。


    什么时候使用接口？
    如果我们知道一个合约实现了IERC721接口，我们不需要知道它具体代码实现，就可以与它交互。

    无聊猿BAYC属于ERC721代币，实现了IERC721接口的功能。我们不需要知道它的源代码，只需知道它的合约地址，用IERC721接口就可以与它交互，比如用balanceOf()来查询某个地址的BAYC余额，用safeTransferFrom()来转账BAYC。

*/