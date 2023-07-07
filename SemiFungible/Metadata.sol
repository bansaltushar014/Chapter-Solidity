
// SPDX-License-Identifier: GPL-3.0


pragma solidity ^0.8.0;
import "./Fungible.sol";

contract Metadata{
     
     Fungible public token;

     constructor(address _tokenAddress){
         token=Fungible(_tokenAddress);
     }

     function constructContractURI(string memory _imageLink) public view returns(string memory){
         return(
             string(abi.encodePacked(
                 'data:application/json;',
                                     Base64.encode(
                        abi.encodePacked(
                            '{"name":"', 
                            token.name(),
                            
                            '","image":"',
                            _imageLink,
                            
                            
                            '"}'
                        )
                    )
             ))

         );
     }


      function contractURI(string memory _imageLink) public pure returns (string memory) {
        string memory json = '{"name": token.name(),"image":_imageLink}';
        return string.concat("data:application/json;utf8,", json);
    }

     

}
