//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./utils/Initializable.sol";
import "./utils/Permissions.sol";
import "./interfaces/ICollectionCoreV1.sol";
import "./ERC721.sol";

/**
 * @title CollectionCoreV1
 * @author Kelton Madden
 *
 * @dev Customizeable collection logic
 */

//eips? 1967 2981 165
//ownable, admin
contract CollectionCore is ICollectionCore, ERC721, Permissions, Initializable {

    uint public _totalSupply;
    uint public _maxSupply;
    uint public _price;
    uint public _primaryRoyaltyPercentage; // input divided by 1000 to calculate percentage (155 -> 15.5%)
    uint public _maxPurchaseNumber;
    uint public _reserveNumber;
    address constant alexandriaAdmin = address();
    string _contractURI;

    function initialize(string calldata name, string calldata symbol, string calldata contractURI_, string calldata baseURI, uint maxSupply, 
        uint price, uint8 primaryRoyaltyPercentage, uint8 maxPurchaseNumber, uint reserveNumber, address payoutAddress) external initializer {
            //initialize ERC20
            _contractURI = contractURI_;
            _price = price;
            _maxSupply = maxSupply;
            _setBaseURI(baseURI);
            _primaryRoyaltyPercentage = primaryRoyaltyPercentage;
            _maxPurchaseNumber = maxPurchaseNumber;
            _reserveNumber = reserveNumber;
            setOwnerInternal(payoutAddress);
            setAdminInternal(alexandriaAdmin);
    }
    
    
    
    
    
    
    
    function publisherWithdraw() external onlyOwner {}
    function adminWithdraw() external onlyAdmin {}                                                                       
    function mint(uint8 number, address recipient) external payable {}
    function totalSupply() external returns (uint8) {}
    function pauseMint(bool) external onlyOwner {}
    function mintStatus() external returns (bool) {}
    function contractURI() public view returns (string memory) {}
    function reserveMint() external {}
}