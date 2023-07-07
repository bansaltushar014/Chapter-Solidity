

// SPDX-License-Identifier: GPL-3.0


pragma solidity ^0.8.0;
import "./Token.sol";

contract Fungible is Token{

    constructor(string memory _name,string memory _symbol) Token(_name,_symbol){

    }

    function mint(address _to,uint _value,uint _slot) public  {
         _mint(_to,_slot,_value);
        
    }
   

}
