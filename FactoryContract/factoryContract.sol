// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Account {
    address public bank;
    address public owner;

    constructor (address _owner) payable {
        bank = msg.sender;
        owner = _owner;
    }
}

contract AccountFactory {
    Account[] public accounts;
    function createAccount() external payable {
        Account account = new Account{value: msg.value}(msg.sender);
        accounts.push(account);
    }
}