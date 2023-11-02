// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC1271Wallet {
  function isValidSignature(bytes32 hash, bytes calldata signature) external view returns (bytes4 magicValue);
  
}


error ERC6492DeployFailed(bytes error);


contract ERC6492{

  bytes32 private constant ERC6492_DETECTION_SUFFIX = 0x6492649264926492649264926492649264926492649264926492649264926492;
  bytes4 private constant ERC1271_SUCCESS = 0x1626ba7e;


  

  bytes4 public magicvalue;

  bool public validation;


  function isValidSigImpl(address _signer,bytes32 _hash,bytes calldata _signature) public  returns (bool validated) {
    uint contractCodeLen = address(_signer).code.length;
    bytes memory sigToValidate;

    bool isCounterfactual = bytes32(_signature[_signature.length-32:_signature.length]) == ERC6492_DETECTION_SUFFIX;
    if (isCounterfactual) {
      address create2Factory;
      bytes memory factoryCalldata;
      (create2Factory, factoryCalldata, sigToValidate) = abi.decode(_signature[0:_signature.length-32], (address, bytes, bytes));

      if (contractCodeLen == 0) {
        (bool success, bytes memory err) = create2Factory.call(factoryCalldata);
        if (!success) revert ERC6492DeployFailed(err);
      }
    } else {
      sigToValidate = _signature;
    }


    if(isCounterfactual)
    {
        magicvalue=IERC1271Wallet(_signer).isValidSignature(_hash,sigToValidate);

        if(magicvalue==ERC1271_SUCCESS)
        {
            validation=true;
            return validation;
        }

        validation=false;

        return validation;





    }

  }


}