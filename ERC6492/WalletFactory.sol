// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import {Wallet} from "./Wallet.sol";
import {Create2} from "@openzeppelin/contracts/utils/Create2.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract WalletFactory {
    Wallet public immutable walletImplementation;

    constructor() {
        walletImplementation = new Wallet(address(this));
    }

    function createAccount(address _owner,uint256 salt) external returns (Wallet) {
        address addr = getAddress(_owner, salt);
        uint256 codeSize = addr.code.length;
        if (codeSize > 0) {
            return Wallet(payable(addr));
        }

        bytes memory walletInit = abi.encodeCall(Wallet.initialize, _owner);
        ERC1967Proxy proxy = new ERC1967Proxy{salt: bytes32(salt)}(
            address(walletImplementation),
            walletInit
        );

        return Wallet(payable(address(proxy)));
    }

    function getAddress(
        address _owner,
        uint256 salt
    ) public view returns (address) {
        bytes memory walletInit = abi.encodeCall(Wallet.initialize, _owner);
        bytes memory proxyConstructor = abi.encode(
            address(walletImplementation),
            walletInit
        );
        bytes memory bytecode = abi.encodePacked(
            type(ERC1967Proxy).creationCode,
            proxyConstructor
        );

        bytes32 bytecodeHash = keccak256(bytecode);

        return Create2.computeAddress(bytes32(salt), bytecodeHash);
    }
}