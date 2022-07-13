//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./utils/Initializable.sol";
import "./interfaces/ICollectionCoreV1.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * @title CollectionCoreV1
 * @author Kelton Madden
 *
 * @dev Customizeable collection logic
 */

contract CollectionCore is ICollectionCore, ERC721, Initializable {

}