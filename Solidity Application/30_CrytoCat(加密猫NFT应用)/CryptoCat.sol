// SPDX-License-Identifier: MIT
// NFT 非同质化加密猫示例
pragma solidity ^0.8.0;

import "../../openzeppelin/token/ERC721/IERC721.sol";
import "../../openzeppelin/token/ERC721/IERC721Receiver.sol";
import "../../openzeppelin/utils/introspection/ERC165.sol";
import "../01_ERC20/SafeMath.sol";

contract CryptoCat is IERC721, ERC165 {
    using SafeMath for uint256;

    uint256 constant dnaDigits = 10;
    uint256 constant dnaModulus = 10 ** dnaDigits;
    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

    struct Cat {
        string name;
        uint256 dna;
    }

    // Creates an empty array of Cat structs
    Cat[] public cats;

    // Mapping from cat ID to its owner's address
    mapping(uint256 => address) public catToOwner;

    // Mapping from owner's address to number of owned token
    mapping(address => uint256) public ownerCatCount;

    // Mapping from token ID to approved address
    mapping(uint256 => address) catApprovals;

    // You can nest mappings, this example maps owner to operator approvals
    mapping(address => mapping(address => bool)) private operatorApprovals;

    // Internal function to create a random Cat from string (name) and DNA
    function _createPizza(
        string memory _name,
        uint256 _dna
    ) internal isUnique(_name, _dna) {
        // Adds Cat to array of Pizzas and get id
        uint256 id = SafeMath.sub(cats.push(Cat(_name, _dna)), 1);
        assert(catToOwner[id] == address(0));

        // Maps the Cat to the owner
        catToOwner[id] = msg.sender;
        ownerCatCount[msg.sender] = SafeMath.add(ownerCatCount[msg.sender], 1);
    }

    // Creates a random Cat from string (name)
    function createRandomPizza(string memory _name) public {
        uint256 randDna = generateRandomDna(_name, msg.sender);
        _createPizza(_name, randDna);
    }

    // Generates random DNA from string (name) and address of the owner (creator)
    function generateRandomDna(
        string memory _str,
        address _owner
    ) public pure returns (uint256) {
        // Generates random uint from string (name) + address (owner)
        uint256 rand = uint256(keccak256(abi.encodePacked(_str))) +
            uint256(_owner);
        rand = rand % dnaModulus;
        return rand;
    }

    // Returns array of Pizzas found by owner
    function getPizzasByOwner(
        address _owner
    ) public view returns (uint256[] memory) {
        uint256[] memory result = new uint256[](ownerCatCount[_owner]);
        uint256 counter = 0;
        for (uint256 i = 0; i < cats.length; i++) {
            if (catToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    // 转移 Cat 和归属关系到其它地址
    function transferFrom(address _from, address _to, uint256 _pizzaId) public {
        require(_from != address(0) && _to != address(0), "Invalid address.");
        require(_exists(_pizzaId), "Cat does not exist.");
        require(_from != _to, "Cannot transfer to the same address.");
        require(
            _isApprovedOrOwner(msg.sender, _pizzaId),
            "Address is not approved."
        );

        ownerCatCount[_to] = SafeMath.add(ownerCatCount[_to], 1);
        ownerCatCount[_from] = SafeMath.sub(ownerCatCount[_from], 1);
        catToOwner[_pizzaId] = _to;

        // 触发继承自 IERC721 合约中定义的事件。
        emit Transfer(_from, _to, _pizzaId);
        _clearApproval(_to, _pizzaId);
    }

    /**
     * 安全转账给定代币 ID 的所有权到其它地址
     * 如果目标地址是一个合约，则该合约必须实现 `onERC721Received`函数,
     * 该函数调用了安全转账并且返回一个 magic value。
     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`;
     * 否则，转账被回退。
     */
    function safeTransferFrom(address from, address to, uint256 catId) public {
        // solium-disable-next-line arg-overflow
        this.safeTransferFrom(from, to, catId, "");
    }

    /**
     * 安全转账给定代币 ID 所有权到其它地址
     * 如果目标地址是一个合约，则该合约必须实现 `onERC721Received` 函数，
     * 该函数调用安全转账并返回一个 magic value
     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`;
     * 否则，转账被回退。
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 catId,
        bytes memory _data
    ) public {
        this.transferFrom(from, to, catId);
        require(
            _checkOnERC721Received(from, to, catId, _data),
            "Must implement onERC721Received."
        );
    }

    /**
     * Internal function to invoke `onERC721Received` on a target address
     * The call is not executed if the target address is not a contract
     */
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 catId,
        bytes memory _data
    ) internal returns (bool) {
        if (!isContract(to)) {
            return true;
        }

        bytes4 retval = IERC721Receiver(to).onERC721Received(
            msg.sender,
            from,
            catId,
            _data
        );
        return (retval == _ERC721_RECEIVED);
    }

    // Burns a Cat - destroys Token completely
    // The `external` function modifier means this function is
    // part of the contract interface and other contracts can call it
    function burn(uint256 _catId) external {
        require(msg.sender != address(0), "Invalid address.");
        require(_exists(_catId), "Cat does not exist.");
        require(
            _isApprovedOrOwner(msg.sender, _catId),
            "Address is not approved."
        );

        ownerCatCount[msg.sender] = SafeMath.sub(ownerCatCount[msg.sender], 1);
        catToOwner[_catId] = address(0);
    }

    // Returns count of Pizzas by address
    function balanceOf(address _owner) public view returns (uint256 _balance) {
        return ownerCatCount[_owner];
    }

    // Returns owner of the Cat found by id
    function ownerOf(uint256 _catId) public view returns (address _owner) {
        address owner = catToOwner[_catId];
        require(owner != address(0), "Invalid Cat ID.");
        return owner;
    }

    // Approves other address to transfer ownership of Cat
    function approve(address _to, uint256 _catId) public {
        require(msg.sender == catToOwner[_catId], "Must be the Cat owner.");
        catApprovals[_catId] = _to;
        emit Approval(msg.sender, _to, _catId);
    }

    // Returns approved address for specific Cat
    function getApproved(
        uint256 _catId
    ) public view returns (address operator) {
        require(_exists(_catId), "Cat does not exist.");
        return catApprovals[_catId];
    }

    /**
     * Private function to clear current approval of a given token ID
     * Reverts if the given address is not indeed the owner of the token
     */
    function _clearApproval(address owner, uint256 _catId) private {
        require(catToOwner[_catId] == owner, "Must be pizza owner.");
        require(_exists(_catId), "Cat does not exist.");
        if (catApprovals[_catId] != address(0)) {
            catApprovals[_catId] = address(0);
        }
    }

    /*
     * Sets or unsets the approval of a given operator
     * An operator is allowed to transfer all tokens of the sender on their behalf
     */
    function setApprovalForAll(address to, bool approved) public {
        require(to != msg.sender, "Cannot approve own address");
        operatorApprovals[msg.sender][to] = approved;
        emit ApprovalForAll(msg.sender, to, approved);
    }

    // Tells whether an operator is approved by a given owner
    function isApprovedForAll(
        address owner,
        address operator
    ) public view returns (bool) {
        return operatorApprovals[owner][operator];
    }

    // Takes ownership of Cat - only for approved users
    function takeOwnership(uint256 _catId) public {
        require(
            _isApprovedOrOwner(msg.sender, _catId),
            "Address is not approved."
        );
        address owner = this.ownerOf(_catId);
        this.transferFrom(owner, msg.sender, _catId);
    }

    // Checks if Cat exists
    function _exists(uint256 _catId) internal view returns (bool) {
        address owner = catToOwner[_catId];
        return owner != address(0);
    }

    // Checks if address is owner or is approved to transfer Cat
    function _isApprovedOrOwner(
        address spender,
        uint256 catId
    ) internal view returns (bool) {
        address owner = catToOwner[catId];
        return (spender == owner ||
            this.getApproved(catId) == spender ||
            this.isApprovedForAll(owner, spender));
    }

    // Check if Cat is unique and doesn't exist yet
    modifier isUnique(string memory _name, uint256 _dna) {
        bool result = true;
        for (uint256 i = 0; i < cats.length; i++) {
            if (
                keccak256(abi.encodePacked(cats[i].name)) ==
                keccak256(abi.encodePacked(_name)) &&
                cats[i].dna == _dna
            ) {
                result = false;
            }
        }
        require(result, "Cat with such name already exists.");
        _;
    }

    // Returns whether the target address is a contract
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }
}
