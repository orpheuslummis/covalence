// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/access/AccessControl.sol";

/*
group management system
there is one contract 'owner' with admin rights over the system
users can create a new group
the creator a group is its admin
the admin can transfer its admin role to a different user
the admin can add or remove members to the group
users can leave gruops
*/

contract GroupManagement is AccessControl {
    bytes32 public constant SYSTEM_ADMIN_ROLE = keccak256("SYSTEM_ADMIN_ROLE");

    struct Group {
        bytes32 cid; // Content Identifier for off-chain metadata
    }

    mapping(uint256 => Group) public groups;
    mapping(uint256 => mapping(address => bool)) public groupMembers;

    uint256 public nextGroupId = 1;

    event GroupCreated(uint256 groupId, bytes32 cid, address indexed admin);
    event AdminChanged(uint256 groupId, address indexed newAdmin, address indexed oldAdmin);
    event UserJoinedGroup(uint256 groupId, address indexed user);
    event UserLeftGroup(uint256 groupId, address indexed user);

    modifier onlySystemAdmin() {
        _checkRole(SYSTEM_ADMIN_ROLE, msg.sender);
        _;
    }

    modifier groupExists(uint256 groupId) {
        require(groups[groupId].cid != bytes32(0), "Group does not exist");
        _;
    }

    constructor() {
        _setupRole(SYSTEM_ADMIN_ROLE, msg.sender);
    }

    function createGroup(bytes32 cid) external {
        require(cid != bytes32(0), "CID cannot be empty");
        groups[nextGroupId] = Group(cid);
        bytes32 groupAdminRole = keccak256(abi.encodePacked("GROUP_ADMIN_ROLE", nextGroupId));
        _setupRole(groupAdminRole, msg.sender);
        emit GroupCreated(nextGroupId, cid, msg.sender);
        nextGroupId++;
    }

    function changeAdmin(uint256 groupId, address newAdmin) external groupExists(groupId) {
        bytes32 groupAdminRole = keccak256(abi.encodePacked("GROUP_ADMIN_ROLE", groupId));
        require(hasRole(groupAdminRole, msg.sender), "Unauthorized");
        _setupRole(groupAdminRole, newAdmin);
        _revokeRole(groupAdminRole, msg.sender);
        emit AdminChanged(groupId, newAdmin, msg.sender);
    }

    function addMember(uint256 groupId, address newMember) external groupExists(groupId) {
        bytes32 groupAdminRole = keccak256(abi.encodePacked("GROUP_ADMIN_ROLE", groupId));
        require(hasRole(groupAdminRole, msg.sender), "Unauthorized");
        groupMembers[groupId][newMember] = true;
        emit UserJoinedGroup(groupId, newMember);
    }

    function removeMember(uint256 groupId, address member) external groupExists(groupId) {
        bytes32 groupAdminRole = keccak256(abi.encodePacked("GROUP_ADMIN_ROLE", groupId));
        require(hasRole(groupAdminRole, msg.sender), "Unauthorized");
        delete groupMembers[groupId][member];
        emit UserLeftGroup(groupId, member);
    }

    function leaveGroup(uint256 groupId) external groupExists(groupId) {
        delete groupMembers[groupId][msg.sender];
        emit UserLeftGroup(groupId, msg.sender);
    }

    function isMemberOfGroup(uint256 groupId, address user) external view groupExists(groupId) returns (bool) {
        return groupMembers[groupId][user];
    }
}
