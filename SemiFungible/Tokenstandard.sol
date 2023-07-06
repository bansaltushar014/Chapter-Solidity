

// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Token {
   mapping(uint=>uint) public balanceOf;
   string private _name;
   string private _symbol;
   using Strings for uint;
   using Counters for Counters.Counter;
   Counters.Counter private _tokenIdGenerator;
   constructor(string memory name_,string memory symbol_) {
       _name=name_;
       _symbol=symbol_;
   }

   struct TokenData{
       uint id;
       uint slot;
       uint balance;
       address owner;
       address approved;
       address[] valueApprovals;
   }

   struct AddressData{
       uint[] ownedTokens;
       mapping(uint=>uint) ownedTokenIndex;
       mapping(address=>bool) approval;
   }
TokenData[] private _allTokens;
mapping(uint=>uint) private _allTokenIndex;
mapping(address=>AddressData) private _addressData;



   function _baseURI() internal view virtual  returns(string memory){
       return "";
   }

//    function contractURI() public view virtual  returns(string memory){
//     //    string memory baseURI=_baseURI();
//        return(
//            string(abi.encodePacked(
               
//                    'data:application/json;',
//                     Base64.encode(
//                         abi.encodePacked(
//                             '{"name":"', 
//                            _name,
//                             '","description":"',
//                             "2",
                            
//                             '"}'
//                         )
//                     )
                    
                   
               
//            ))
//        );
       
//    }

// function contractURI() public pure returns (string memory) {
//         string memory json = '{"name": "Opensea Creatures","description":"..."}';
//         return string.concat("data:application/json;utf8,", json);
//     }
//  function contractURI() public pure returns (string memory) {
//         return "https://metadata-url.com/my-metadata";
//     }

    function contractURI() public view virtual returns(string memory){
        string memory baseURI=_baseURI();
        return bytes(baseURI).length > 0  ? string(abi.encodePacked(baseURI,"contract/",Strings.toHexString(address(this)))):"";
        
    }

    function slotURI(uint slot_) public view virtual returns(string memory){
       string memory baseURI=_baseURI();
        return bytes(baseURI).length >0 ? string(abi.encodePacked(baseURI,"slot/",slot_.toString())):"";

    }

    function tokenURI(uint _tokenId) public view virtual returns(string memory){
        string memory baseURI=_baseURI();
        return bytes(baseURI).length >0 ? string(abi.encodePacked(baseURI,_tokenId.toString())):"";
    }

//    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
//         return
//             interfaceId == type(IERC165).interfaceId ||
//             interfaceId == type(IERC3525).interfaceId ||
//             interfaceId == type(IERC721).interfaceId ||
//             interfaceId == type(IERC3525Metadata).interfaceId ||
//             interfaceId == type(IERC721Enumerable).interfaceId || 
//             interfaceId == type(IERC721Metadata).interfaceId;
//     }

    function name() public virtual  returns(string memory){
        return _name;
    }

    function _mint(address to_,uint slot_,uint value_) internal virtual{
        uint tokenId=_createOriginalTokenId();
        _mint(to_,tokenId,slot_,value_);

    }

    function _mint(address to_,uint tokenId_,uint slot_,uint value_) internal virtual{
        require(to_!=address(0),"mint to zero address");
        require(tokenId_!=0,"tokenId must be there to mint");
        require(slot_!=0,"slot must not be zero");
        require(!exist(tokenId_),"Token already existed");
        _mintToken(to_,tokenId_,slot_);
        _mintValue(tokenId_,value_);


    

    }

    

    function exist(uint tokenId_) internal view returns(bool){
        return _allTokens.length >0 && _allTokens[_allTokenIndex[tokenId_]].id==tokenId_;

    }

    
    function _createOriginalTokenId() internal  returns(uint){
    _tokenIdGenerator.increment();
    return _tokenIdGenerator.current();

    }

    function _mintToken(address to_,uint tokenId_,uint slot_) internal virtual{
       TokenData memory tokendata=TokenData({
         id:tokenId_,
         slot:slot_,
         balance:0,
         owner:to_,
         approved:address(0),
         valueApprovals:new address[](0)
       });
       _addTokenToAllTokensEnumeration(tokendata);
       _addTokenToOwnerEnumeration(to_,tokenId_);
       

    }

    function _mintValue(uint _tokenId,uint _value) internal{
        _allTokens[_allTokenIndex[_tokenId]].balance+=_value;
        
    }

    function _addTokenToAllTokensEnumeration(TokenData memory _tokenData) internal{
        _allTokenIndex[_tokenData.id]=_allTokens.length;
        _allTokens.push(_tokenData);
    }

    function _addTokenToOwnerEnumeration(address to_,uint tokenId_) internal{
        _addressData[to_].ownedTokenIndex[tokenId_]=_addressData[to_].ownedTokens.length;
        _addressData[to_].ownedTokens.push(tokenId_);
    }

    


  

    



}
