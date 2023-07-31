// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Storage{
    
    mapping(bytes32=>uint) uintVars;
    mapping(bytes32=>string) stringVars;
    
    
    function setUintVars(bytes32 varName, uint value)public {
        uintVars[varName] = value;
    }
    
    function getUintVarsValue(bytes32 varName)public view returns(uint){
        return uintVars[varName];
    }
    
    function setStringVars(bytes32 varName, string calldata value)public {
        stringVars[varName] = value;
    }
    
    function getStringVarsValue(bytes32 varName)public view returns(string memory){
        return stringVars[varName];
        
    }

}

library StorageLib{
    
    function setXVar(address storageContractAddress, uint value)public {
        Storage(storageContractAddress).setUintVars(keccak256('x'),value);
    }
    
    function getXVar(address storageContractAddress)public view returns(uint){
       return Storage(storageContractAddress).getUintVarsValue(keccak256('x'));
    } 
    
    function setUserNameVar(address storageContractAddress, string memory value)public {
        Storage(storageContractAddress).setStringVars(keccak256('Username'),value);
    }
    
    function getUserNameVar(address storageContractAddress)public view returns(string memory){
       return Storage(storageContractAddress).getStringVarsValue(keccak256('Username'));
    }
}
