// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title ERC20 Token Contract
 * @dev This contract implements the ERC20 token standard with additional features.
 */
contract ERC20 {
    // Events
    event Mint(address indexed minterAddress, uint256 tokenAmount);
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 tokenAmount
    );
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    // Token balance for each address
    mapping(address => uint256) public tokenBalance;

    // Allowances for address to spend tokens on behalf of another address
    mapping(address => mapping(address => uint256)) public allowances;

    // Total supply of the token
    uint256 public _totalSupply;

    // Owner of the contract
    address public owner;

    // Name of the token
    string public _name;

    // Symbol of the token
    string public _symbol;

    /**
     * @dev Constructor to initialize the token name, symbol, and owner.
     * @param tokenName The name of the token.
     * @param tokenSymbol The symbol of the token.
     */
    constructor(string memory tokenName, string memory tokenSymbol) {
        _name = tokenName;
        _symbol = tokenSymbol;
        owner = msg.sender;
    }

    /**
     * @dev Modifier to restrict access to the owner of the contract.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Address not allowed");
        _;
    }

    /**
     * @dev Get the name of the token.
     * @return The name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Get the symbol of the token.
     * @return The symbol of the token.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Get the decimals of the token.
     * @return The decimals of the token.
     */
    function decimals() public view returns (uint8) {
        return 18;
    }

    /**
     * @dev Get the total supply of the token.
     * @return The total supply of the token.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev Get the balance of tokens owned by the message sender.
     * @return The balance of tokens owned by the message sender.
     */
    function balanceOf(address _owner) public view returns (uint256) {
        return tokenBalance[_owner];
    }

    /**
     * @dev Get the allowance that owner approved to the address.
     * @param _owner Input the address that approved.
     * @param _spender Input the address that was approved.
     * @return The allowance that owner approved to the address.
     */
    function allowance(
        address _owner,
        address _spender
    ) public view returns (uint256) {
        return allowances[_owner][_spender];
    }

    /**
     * @dev Approve another address to spend a specified amount of tokens on behalf of the message sender.
     * @param amount The amount of tokens to approve.
     * @param _address The address to grant the approval.
     * @return True if the approval.
     */
    function approve(address _address, uint256 amount) public returns (bool) {
        require(_address != address(0), "Address not available");
        allowances[msg.sender][_address] = amount;
        emit Approval(msg.sender, _address, amount);
        return true;
    }

    /**
     * @dev Transfer tokens from one address to another based on an allowance.
     * @param from The sender's address.
     * @param to The recipient's address.
     * @param amount The amount of tokens to transfer.
     * @return True if the transfer.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        require(to != address(0), "Address not available");
        require(allowances[from][to] >= amount, "Allowance not high enough");
        require(tokenBalance[from] >= amount, "Balance not high enough");
        tokenBalance[from] -= amount;
        tokenBalance[to] += amount;
        allowances[from][to] -= amount;
        emit Transfer(from, to, amount);
        return true;
    }

    /**
     * @dev Transfer tokens from the message sender to another address.
     * @param to The recipient's address.
     * @param amount The amount of tokens to transfer.
     * @return True if the transfer
     */
    function transfer(address to, uint256 amount) public returns (bool) {
        require(to != address(0), "Address not available");
        require(tokenBalance[msg.sender] >= amount, "Balance not high enough");
        tokenBalance[msg.sender] -= amount;
        tokenBalance[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    /**
     * @dev Mint new tokens and assign them to a specified address.
     * @param to The recipient's address.
     * @param amount The amount of tokens to mint.
     */
    function mint(address to, uint256 amount) public onlyOwner {
        _totalSupply += amount;
        tokenBalance[to] += amount;
        emit Mint(to, amount);
    }

    /**
     * @dev Burn a specified amount of tokens, reducing the total supply.
     * @param amount The amount of tokens to burn.
     */
    function burn(uint256 amount) public {
        require(tokenBalance[msg.sender] >= amount, "Balance not high enough");
        tokenBalance[msg.sender] -= amount;
        _totalSupply -= amount;
        tokenBalance[address(0)] += amount;
    }
}
