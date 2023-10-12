// Contract B
pragma solidity ^0.8.0;

contract ContractB {
    address public contractAAddress;
    uint256 public data;
    

    function setContractAAddress(address _address) public {
        contractAAddress = _address;
    }

    function CallToContractA(uint256 _data) public payable {
        // Perform call to Contract A's setData function
        (bool success, ) = contractAAddress.call{value: msg.value}(abi.encodeWithSignature("setData(uint256)", _data));
        require(success, "call failed");
    }

    // This function performs call to Contract A's setData function and allows the user to specify the amount of gas sent along with the function
    function callToContractA(uint256 _data, uint256 _gas) public payable {
        (bool success, ) = contractAAddress.call{value: msg.value, gas: _gas}(abi.encodeWithSignature("setData(uint256)", _data));
        require(success, "call failed");
    }

    function testCallDoesNotExist() public payable {
        (bool success, ) = contractAAddress.call{value: msg.value}(
            abi.encodeWithSignature("doesNotExist()")
        );
        require(success, "Test call failed");
    }
}
