// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC1271Wallet {
  function isValidSignature(bytes32 hash, bytes calldata signature) external view returns (bytes4 magicValue);
}

contract VerifySignature{
    bytes4 private constant ERC1271_SUCCESS = 0x1626ba7e;

    function getEthSignedMessageHash( bytes32 _messageHash) public pure returns (bytes32) {

        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));
   
    }

    function getMessageHash(string memory _message) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_message));
    }


    function verify(address _signer,bytes32 hash,bytes memory _signature) public  view returns(bool dataverification){
         bytes memory contractCode = address(_signer).code;

         
    if (contractCode.length > 0) {
      
      bool data= IERC1271Wallet(_signer).isValidSignature(hash, _signature) == ERC1271_SUCCESS;
      require(data,"Address is not the owner");
      return data;
    }

    }


}
