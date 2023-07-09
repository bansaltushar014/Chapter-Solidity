pragma solidity ^0.8.0;

library ArrayLib {
  function find (uint[] storage arr, uint[] storage arr2, uint x) internal view returns (uint) {
  for (uint i = 0; i < arr.length; i++) {
  if (arr[i] == x) {
    return i;
    }
  }
  revert ("not found");
  }
}

contract TestArray {
  using ArrayLib for uint[];
  uint[] public arr = [3,2,1];
  uint[] public arr2 = [7,9];

  function testFind1(uint x) external view returns (uint i) {
   return arr.find(arr2,x);
  }

  function testFind2(uint x) external view returns (uint i) {
   return arr2.find(arr,x);
  }
}
