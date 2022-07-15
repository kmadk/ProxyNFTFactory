//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title ICollectionCoreV1
 * @author Kelton Madden
 *
 * @dev Interface for collection logic
 */

interface ICollectionCore {
    function initialize(string calldata name, string calldata symbol, string calldata contractURI, string calldata tokenURI, uint supply, uint price, uint8 primaryRoyaltyPercentage,
        uint8 maxPurchaseNumber, uint reserveNumber) external;
    function publisherWithdraw() external;
    function adminWithdraw() external;                                                                       
    function mint(uint8 number, address recipient) external payable;
    function totalSupply() external returns (uint8);
    function pauseMint(bool) external;
    function mintStatus() external returns (bool);
    function mintPrice() external returns (uint256);
    function reserveMint() external;
}