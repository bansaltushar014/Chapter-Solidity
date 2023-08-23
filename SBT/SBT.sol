pragma solidity ^0.8.0;

contract MySBT {
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    constructor() {}

    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "Invalid address");
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "Token does not exist");
        return owner;
    }

    function transfer(address to, uint256 tokenId) public {
        require(to != address(0), "Invalid address");
        require(_owners[tokenId] == msg.sender, "You don't own this token");

        revert("Transfer not applicable");
    }

    function _transfer(address from, address to, uint256 tokenId) internal {
        _owners[tokenId] = to;
        _balances[from] -= 1;
        _balances[to] += 1;

        emit Transfer(from, to, tokenId);
    }

    function mint(address to, uint256 tokenId) public {
        require(to != address(0), "Invalid address");
        require(_owners[tokenId] == address(0), "Token already minted");

        _owners[tokenId] = to;
        _balances[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }
}