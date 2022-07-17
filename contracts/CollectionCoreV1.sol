//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/ICollectionCoreV1.sol";
import "./ERC721Upgradeable.sol";
import "./utils/Permissions.sol";

/**
 * @title CollectionCoreV1
 * @author Kelton Madden
 *
 * @dev Customizeable collection logic
 */

//eips? 1967 2981 165
//ownable, admin
contract CollectionCore is ICollectionCore, ERC721Upgradeable, Permissions {

    bool public _mintState;
    uint public _totalSupply;
    uint public _maxSupply;
    uint public _price;
    uint public _primaryRoyaltyPercentage; // input divided by 1000 to calculate percentage (155 -> 15.5%)
    uint public _maxPurchaseNumber;
    uint public _reserveNumber;
    uint public _ownerFunds;
    uint public _adminFunds;
    //address constant alexandriaAdmin = address(0);
    string _contractURI;

    function initialize(string calldata name, string calldata symbol, InitializationData calldata parameters) external override initializer {
        __ERC721_init(name, symbol);
        _totalSupply = 0;
        _ownerFunds = 0;
        _adminFunds = 0;
        _maxSupply = parameters.maxSupply;
        _price = parameters.price;
        _primaryRoyaltyPercentage = parameters.primaryRoyaltyPercentage;
        _maxPurchaseNumber = parameters.maxPurchaseNumber;
        _reserveNumber = parameters.reserveNumber;
        _contractURI = parameters.contractURI;
        _setBaseURI(parameters.baseURI);
        setOwnerInternal(parameters.payoutAddress);
        setAdminInternal(parameters.alexandriaAddress);
    }
    
    function mint(uint8 number, address recipient) external override payable {
        require(_mintState, "minting is not enabled");
        require(number <= _maxPurchaseNumber, "number of mints exceeds max purchase number");
        require(_totalSupply + number <= _maxSupply, "total supply exceeds max supply");

    }

    function ownerWithdraw() external override onlyOwner {
        uint amount = _ownerFunds;
        _ownerFunds = 0;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed.");
    }

    function adminWithdraw() external override onlyAdmin {     
        uint amount = _adminFunds;
        _adminFunds = 0;                                                                  
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed.");
    }

    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }

    function changeMintState(bool mintState) external override onlyOwner {
        _mintState = mintState;
    }

    function contractURI() public view returns (string memory) {
        return _contractURI;
    }

    function reserveMint() external override {}
}