// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/proxy/Proxy.sol";

contract MyProxy is Proxy {
    address public implmentation; 

    function setImplementation(address _implementation) public {
         implmentation = _implementation; 
    }

    function _implementation() internal view override  virtual returns (address){
         return implmentation; 
    }
}
