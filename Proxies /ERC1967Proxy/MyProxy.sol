// contracts/Box.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract MyProxy is ERC1967Proxy {
   
    constructor(address _logic, bytes memory _data)  ERC1967Proxy(_logic, _data) {}

    function setImplmentation(address _logic, bytes memory _data) public{
        // ERC1967Upgrade.upgradeToAndCall(_logic);
        ERC1967Upgrade._upgradeTo(_logic);
    }
  
    // debug method to expose the address
    function getImplementationAddress() public view returns(address) {
        return ERC1967Upgrade._getImplementation();
    }   
}