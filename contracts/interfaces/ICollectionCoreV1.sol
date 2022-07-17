//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title ICollectionCoreV1
 * @author Kelton Madden
 *
 * @dev Interface for collection logic
 */

struct InitializationData {
        uint maxSupply;
        uint price;
        uint primaryRoyaltyPercentage;
        uint maxPurchaseNumber;
        uint reserveNumber;
        string contractURI;
        string baseURI;
        address payoutAddress;
        address alexandriaAddress;
}

interface ICollectionCore {
    function initialize(string calldata name, string calldata symbol, InitializationData calldata parameters) external;
    function ownerWithdraw() external;
    function adminWithdraw() external;                                                                       
    function mint(uint8 number, address recipient) external payable;
    function changeMintState(bool) external;
    function reserveMint(address) external;
}