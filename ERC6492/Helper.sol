
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract Helper{

    bytes32 public magicValue=0x6492649264926492649264926492649264926492649264926492649264926492;

    function getFactoryCalldata(address _owner,uint256 _salt) public pure returns(bytes memory){

        bytes memory factorycalldata=abi.encodeWithSignature("createAccount(address,uint256)", _owner,_salt);
        return factorycalldata;


    }

    function createSignature(address _walletfactory,bytes memory _factoryCalldata,bytes calldata _signature) public  view returns(bytes memory){

        bytes memory signature=bytes.concat(abi.encode(_walletfactory,_factoryCalldata,_signature),magicValue);

        return signature;

    }
}
