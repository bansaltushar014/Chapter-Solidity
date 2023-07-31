pragma solidity >=0.7.0 <0.9.0;
import './Storage.sol';

contract BackendContract{
    using StorageLib for address;
    address storageAddr;
    
    constructor(address storageContractAddress){
        storageAddr = storageContractAddress;
    }
    
    function addX(uint a, uint b)public {
        uint x = a + b;
        storageAddr.setXVar(x);
    }
    
    function getX()public view returns(uint){
        return storageAddr.getXVar();
    }
    
}
