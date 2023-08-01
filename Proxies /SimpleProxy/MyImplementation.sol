// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract MyImplementation {
    address public implmentation; 
    uint256 public value;

    function setValue(uint256 _value) external {
        value = _value;
    }

    function getValue() external view returns (uint256) {
        return value;
    }
}
