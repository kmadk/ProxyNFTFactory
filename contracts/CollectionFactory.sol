// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @author: Kelton Madden

import "./CollectionCoreV1.sol";
import "./CollectionProxy.sol";


contract CollectionFactory {

    // address of a proxy => the version of the implementation it uses
    mapping(address => uint) public proxyVersions;
    // version number => address of the implementation for that version
    mapping(uint => address) public implementationAddresses;
    uint public totalVersions;

    event Deployment(address publisher, address proxy, uint version, string name, string symbol, CollectionCoreV1.InitializationData parameters);
    
    function deployCollection(uint8 version, string memory name, string memory symbol, CollectionCoreV1.InitializationData memory parameters) external {
        address implementationAddress = implementationAddresses[version];
        CollectionProxy deployment = new CollectionProxy(implementationAddress, name, symbol, parameters);
        proxyVersions[address(deployment)] = version;

        emit Deployment(msg.sender, address(deployment), version, name, symbol, parameters);
    }

    function addVersion(address implementationAddress) external {
        totalVersions++;
        implementationAddresses[totalVersions] = implementationAddress;
    }
}