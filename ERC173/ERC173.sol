// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ERC-173 interface
interface IERC173 {
    function ownerOf(uint256 tokenId) external view returns (address);
    function transferFrom(address from, address to, uint256 tokenId) external;
}

// ERC-173 contract
contract ERC173 is IERC173 {

    // Mapping of token IDs to owners
    mapping(uint256 => address) public owners;

    // Constructor
    constructor() {}

    // Mints a new token to the specified owner
    function mint(address owner, uint256 tokenId) external {
        owners[tokenId] = owner;
    }

    // Returns the owner of the specified token
    function ownerOf(uint256 tokenId) external view override returns (address) {
        return owners[tokenId];
    }

    // Transfers the ownership of the specified token to the specified recipient
    function transferFrom(address from, address to, uint256 tokenId) external override {
        require(owners[tokenId] == from, "ERC173: not the owner");
        owners[tokenId] = to;
    }
}