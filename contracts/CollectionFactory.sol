// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @author: Kelton Madden

import "./CollectionCoreV1.sol";
import "./CollectionProxyV1.sol";


contract CollectionFactory {

    // address of a proxy => the version of the implementation it uses
    mapping(address => uint) public version;
    // version number => address of the implementation for that version
    mapping(uint => address) public implementationAddresses;


    function deployCollection(string memory name, string memory symbol, CollectionCoreV1.InitializationData memory parameters) external {
            CollectionProxyV1 deployment = new CollectionProxyV1(name, symbol, parameters);
    }


}