// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/access/AccessControl.sol";

/*
A group management system.
- Contract owner (SYSTEM_ADMIN_ROLE) has admin rights over the system.
- Users can create a new group.
- The creator of a group is its admin.
- The admin can transfer its admin role to a different user.
- The admin can add or remove members to/from the group.
- Users can leave groups.
- Admin cannot leave their own group.
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

    modifier groupExists(uint256 groupId) {
        require(groups[groupId].cid != bytes32(0), "Group does not exist");
        _;
    }

    modifier onlyGroupAdmin(uint256 groupId) {
        require(hasRole(_getGroupAdminRole(groupId), msg.sender), "Unauthorized");
        _;
    }

    constructor() {
        _setupRole(SYSTEM_ADMIN_ROLE, msg.sender);
    }

    function _getGroupAdminRole(uint256 groupId) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("GROUP_ADMIN_ROLE", groupId));
    }

    function createGroup(bytes32 cid, address[] calldata initialMembers) external {
        require(cid != bytes32(0), "CID cannot be empty");

        groups[nextGroupId] = Group(cid);
        _setupRole(_getGroupAdminRole(nextGroupId), msg.sender);

        groupMembers[nextGroupId][msg.sender] = true;

        for (uint256 i = 0; i < initialMembers.length; i++) {
            groupMembers[nextGroupId][initialMembers[i]] = true;
        }

        emit GroupCreated(nextGroupId, cid, msg.sender);
        nextGroupId++;
    }

    function changeAdmin(uint256 groupId, address newAdmin) external groupExists(groupId) onlyGroupAdmin(groupId) {
        _setupRole(_getGroupAdminRole(groupId), newAdmin);
        _revokeRole(_getGroupAdminRole(groupId), msg.sender);

        emit AdminChanged(groupId, newAdmin, msg.sender);
    }

    function addMember(uint256 groupId, address newMember) external groupExists(groupId) onlyGroupAdmin(groupId) {
        groupMembers[groupId][newMember] = true;
        emit UserJoinedGroup(groupId, newMember);
    }

    function removeMember(uint256 groupId, address member) external groupExists(groupId) onlyGroupAdmin(groupId) {
        require(groupMembers[groupId][member], "Member does not exist");
        delete groupMembers[groupId][member];
        emit UserLeftGroup(groupId, member);
    }

    function leaveGroup(uint256 groupId) external groupExists(groupId) {
        require(!hasRole(_getGroupAdminRole(groupId), msg.sender), "Group admin cannot leave their own group");

        delete groupMembers[groupId][msg.sender];
        emit UserLeftGroup(groupId, msg.sender);
    }

    function isMemberOfGroup(uint256 groupId, address user) external view groupExists(groupId) returns (bool) {
        return groupMembers[groupId][user];
    }

    function addMembers(uint256 groupId, address[] calldata newMembers)
        external
        groupExists(groupId)
        onlyGroupAdmin(groupId)
    {
        for (uint256 i = 0; i < newMembers.length; i++) {
            groupMembers[groupId][newMembers[i]] = true;
            emit UserJoinedGroup(groupId, newMembers[i]);
        }
    }

    function removeMembers(uint256 groupId, address[] calldata members)
        external
        groupExists(groupId)
        onlyGroupAdmin(groupId)
    {
        for (uint256 i = 0; i < members.length; i++) {
            require(groupMembers[groupId][members[i]], "Member does not exist");
            delete groupMembers[groupId][members[i]];
            emit UserLeftGroup(groupId, members[i]);
        }
    }

    function updateGroupCID(uint256 groupId, bytes32 newCID) external groupExists(groupId) onlyGroupAdmin(groupId) {
        groups[groupId].cid = newCID;
    }
}
