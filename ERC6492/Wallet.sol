// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract Wallet is Initializable{
   

    address public immutable walletFactory;
    
    address public owner;
    

   

    constructor( address ourWalletFactory) {
        
        walletFactory = ourWalletFactory;
    }

    function initialize(address _owner) public initializer {
        owner=_owner;
    }


    function isValidSignature(bytes32 _hash,bytes calldata _signature) external view  returns(bytes4 magicValue){
       
      
         if (recoverSigner(_hash, _signature) == owner) {
      return 0x1626ba7e;
    } else {
      return 0xffffffff;
    }
    }

    function recoverSigner(bytes32 _hash,bytes memory _signature) internal pure returns (address signer) {
    require(_signature.length == 65, "SignatureValidator#recoverSigner: invalid signature length");
bytes32[3] memory _sig;
    // Variables are not scoped in Solidity.
      assembly { 
      _sig := _signature
    }
    bytes32 r = _sig[1];
    bytes32 s = _sig[2];
    uint8 v = uint8(_signature[64]);

    if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
      revert("SignatureValidator#recoverSigner: invalid signature 's' value");
    }

    if (v != 27 && v != 28) {
      revert("SignatureValidator#recoverSigner: invalid signature 'v' value");
    }

    // Recover ECDSA signer
    signer = ecrecover(_hash, v, r, s);
    
    // Prevent signer from being 0x0
    require(
      signer != address(0x0),
      "SignatureValidator#recoverSigner: INVALID_SIGNER"
    );
    

    

    return signer;
  }

}