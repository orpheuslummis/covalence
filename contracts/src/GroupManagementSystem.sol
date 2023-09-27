// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./GroupManagement.sol";

// GroupManagement but with  Contract owner (SYSTEM_ADMIN_ROLE) has admin rights over the system.
contract SystemGroupManagement is AccessControl, GroupManagement {
    bytes32 public constant SYSTEM_ADMIN_ROLE = keccak256("SYSTEM_ADMIN_ROLE");

    event SystemGroupDestroyed(uint256 groupId, address indexed admin);
    event SystemUserRemoved(uint256 groupId, address indexed user);

    constructor() {
        _setupRole(SYSTEM_ADMIN_ROLE, msg.sender);
    }

    function systemRemoveMember(uint256 groupId, address member) external {
        require(hasRole(SYSTEM_ADMIN_ROLE, msg.sender), "Unauthorized");
        removeMember(groupId, member);
        emit SystemUserRemoved(groupId, member);
    }

    function systemReplaceGroupAdmin(uint256 groupId, address newAdmin) external {
        require(hasRole(SYSTEM_ADMIN_ROLE, msg.sender), "Unauthorized");
        require(newAdmin != address(0), "New admin cannot be the zero address");
        _setupRole(_getGroupAdminRole(groupId), newAdmin);
        emit AdminChanged(groupId, newAdmin, msg.sender);
    }

    function systemDestroyGroup(uint256 groupId) external {
        require(hasRole(SYSTEM_ADMIN_ROLE, msg.sender), "Unauthorized");
        require(bytes(groups[groupId].cid).length != 0, "Group does not exist");
        delete groups[groupId];
        emit SystemGroupDestroyed(groupId, msg.sender);
    }
}
