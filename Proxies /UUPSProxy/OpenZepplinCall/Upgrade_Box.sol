// contracts/Box.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Box.sol";

contract BoxUpgrade is Box {
    // uint256 private _value;
    
     function inc() public {
        _value = _value+1;
    }

    function dec() public {
        _value = _value-1;
    }    
}