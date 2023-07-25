// Contract A
pragma solidity ^0.8.0;

contract ContractAUpgrade {
    address public contractAAddress;
    uint256 public data;

    function setData(uint256 _data) public {
        data = _data;
    }

    function getData() view public returns(uint) {
        return data;
    }

    function increment() public {
        data = data + 1;
    }
}
