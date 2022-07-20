//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/ICollectionCoreV1.sol";
import "./utils/Permissions.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";

/**
 * @title CollectionCoreV1
 * @author Kelton Madden
 *
 * @dev Customizeable collection logic
 */

contract CollectionCoreV1 is ICollectionCoreV1, ERC721Upgradeable, Permissions {
    using StringsUpgradeable for uint256;

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
    bool _reserveMintState;
    bool public _mintState;
    uint public _totalSupply;
    uint public _maxSupply;
    uint public _price;
    uint public _primaryRoyaltyPercentage; // input divided by 1000 to calculate percentage (155 -> 15.5%)
    uint public _maxPurchaseNumber;
    uint public _reserveNumber;
    uint public _ownerFunds;
    uint public _adminFunds;
    string baseUri;
    string contractUri;

    function initialize(string calldata name, string calldata symbol, InitializationData calldata parameters) external initializer {
        __ERC721_init(name, symbol);
        _totalSupply = 0;
        _ownerFunds = 0;
        _adminFunds = 0;
        _maxSupply = parameters.maxSupply;
        _price = parameters.price;
        _primaryRoyaltyPercentage = parameters.primaryRoyaltyPercentage;
        _maxPurchaseNumber = parameters.maxPurchaseNumber;
        _reserveNumber = parameters.reserveNumber;
        contractUri = parameters.contractURI;
        baseUri = parameters.baseURI;
        setOwnerInternal(parameters.payoutAddress);
        setAdminInternal(parameters.alexandriaAddress);
    }
    
    function mint(uint8 number, address recipient) external override payable {
        require(_mintState, "minting is not enabled");
        require(number <= _maxPurchaseNumber, "number of mints exceeds max purchase number");
        require(_totalSupply + number <= _maxSupply, "total supply exceeds max supply");
        require(number * _price == msg.value, "invalid payment amount");
        for(uint i = 0; i < number; i++) {
            if (_totalSupply < _maxSupply) {
                _totalSupply++;
                _safeMint(recipient, _totalSupply);
            }
        }
        _ownerFunds += msg.value - msg.value * _primaryRoyaltyPercentage / 1000;
        _adminFunds += msg.value * _primaryRoyaltyPercentage / 1000;
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
        return contractUri;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        _requireMinted(tokenId);

        return bytes(baseUri).length > 0 ? string(abi.encodePacked(baseUri, tokenId.toString())) : "";
    }

    function reserveMint(address recipient) external override {
        require(!_reserveMintState, "already reserve minted");
        _reserveMintState = true;
        for (uint i; i < _reserveNumber; i++) {
            if (_totalSupply < _maxSupply) {
                _totalSupply++;
                _safeMint(recipient, _totalSupply);
            }
        }
    }
}