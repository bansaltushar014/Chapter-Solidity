// Contract A
pragma solidity ^0.8.0;

contract ContractA {
    address public implementation;
    uint256 public data;
    
     event Received(address caller, uint amount, string message);

    fallback() external payable {
        emit Received(msg.sender, msg.value, "Fallback was called");
    }
    
    function setData(uint256 _data) external payable {
        data = _data;
    }

    function getData() view public returns(uint) {
        return data;
    }
}
