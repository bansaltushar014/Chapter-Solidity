// Proxy.sol
pragma solidity ^0.8.0;

contract Proxy {
    address public implementation;
    uint256 public data;

    constructor(address _implementation) {
        implementation = _implementation;
    }

    function _delegate() private {
        (bool ok, ) = implementation.delegatecall(msg.data);
        require(ok, "delegatecall failed");
    }

    fallback() external payable {
        _delegate();
    }

    receive() external payable {
        _delegate();
    }

    function setImplementation(address _implementation) external {
        implementation = _implementation;
    }
}
