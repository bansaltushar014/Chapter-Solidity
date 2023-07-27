// Contract B
pragma solidity ^0.8.0;

contract ContractB {
    address public contractAAddress;

    function setContractAAddress(address _address) public {
        contractAAddress = _address;
    }

    function CallToContractA(uint256 _data) public {
        // Perform call to Contract A's setData function
        (bool success, ) = contractAAddress.call(abi.encodeWithSignature("setData(uint256)", _data));
        require(success, "call failed");
    }

    function staticcallToContractA() view public returns(uint value) {
        (bool success, bytes memory result ) = contractAAddress.staticcall(abi.encodeWithSignature("getData()"));
        require(success, "staticCall failed");
        value = abi.decode(result, (uint256));
    }
}
