// Contract A
pragma solidity ^0.8.0;

contract ContractA {
    address public implementation;
    uint256 public data;
    
    function setData(uint256 _data) public {
        data = _data;
    }

    function getData() view public returns(uint) {
        return data;
    }
}
