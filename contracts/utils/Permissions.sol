// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Permissions
 * @author Kelton Madden
 *
 * @dev Implements only-owner and admin-only functionality
 */

contract Permissions {

    address _owner;
    address _admin;

    event OwnershipChanged(address oldOwner, address newOwner);
    event AdminshipChanged(address oldAdmin, address newAdmin);

    modifier onlyOwner {
        require(_owner == msg.sender, "only-owner");
        _;
    }

    modifier onlyAdmin {
        require(_admin == msg.sender, "only-admin");
        _;
    }

    function setOwner(address newOwner) external onlyOwner {
        setOwnerInternal(newOwner);
    }

    function setOwnerInternal(address newOwner) internal {
        require(newOwner != address(0), "zero-addr");

        address oldOwner = _owner;
        _owner = newOwner;

        emit OwnershipChanged(oldOwner, newOwner);
    }

    function getOwner() external view returns (address) {
        return _owner;
    }


    function setAdmin(address newadmin) external onlyAdmin {
        setAdminInternal(newadmin);
    }

    function setAdminInternal(address newadmin) internal {
        require(newadmin != address(0), "zero-addr");

        address oldadmin = _admin;
        _admin = newadmin;

        emit AdminshipChanged(oldadmin, newadmin);
    }

    function getAdmin() external view returns (address) {
        return _admin;
    }
}