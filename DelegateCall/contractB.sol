// Contract B
pragma solidity ^0.8.0;

contract ContractB {
    address public contractAAddress;
    uint256 public data;
    

    function setContractAAddress(address _address) public {
        contractAAddress = _address;
    }

    function delegateCallToContractA(uint256 _data) public {
        // Perform delegate call to Contract A's setData function
        (bool success, ) = contractAAddress.delegatecall(abi.encodeWithSignature("setData(uint256)", _data));
        require(success, "Delegate call failed");
    }
}
