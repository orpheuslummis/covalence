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

// TODO fix gas inefficiencies such as looping over arrays

contract GroupManagement is AccessControl {
    bytes32 public constant SYSTEM_ADMIN_ROLE = keccak256("SYSTEM_ADMIN_ROLE");
    uint256 public constant batchLimit = 50;

    struct Group {
        string name;
        string cid; // Content Identifier for off-chain metadata
        address[] members;
    }

    mapping(uint256 => Group) public groups;
    mapping(address => uint256[]) public userGroups;

    uint256 public nextGroupId;

    event AdminChanged(uint256 groupId, address indexed newAdmin, address indexed oldAdmin);
    event GroupCreated(uint256 groupId, string cid, address indexed admin);
    event UserJoinedGroup(uint256 groupId, address indexed user);
    event UserLeftGroup(uint256 groupId, address indexed user);
    event CIDUpdated(uint256 groupId, string newCID, string oldCID);
    event SystemGroupDestroyed(uint256 groupId, address indexed admin);
    event SystemUserRemoved(uint256 groupId, address indexed user);
    event GroupNameUpdated(uint256 groupId, string newName, string oldName);

    modifier groupExists(uint256 groupId) {
        require(bytes(groups[groupId].cid).length != 0, "Group does not exist");
        _;
    }

    modifier onlyGroupAdmin(uint256 groupId) {
        require(hasRole(_getGroupAdminRole(groupId), msg.sender), "Unauthorized");
        _;
    }

    constructor() {
        _setupRole(SYSTEM_ADMIN_ROLE, msg.sender);
    }

    function getGroupAdminRole(uint256 groupId) public pure returns (bytes32) {
        return _getGroupAdminRole(groupId);
    }

    function _getGroupAdminRole(uint256 groupId) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("GROUP_ADMIN_ROLE", groupId));
    }

    function createGroup(string memory name, string memory cid, address[] calldata initialMembers)
        external
        returns (uint256)
    {
        require(initialMembers.length <= 100, "Too many initial members");
        require(bytes(cid).length != 0, "CID cannot be empty");

        for (uint256 i = 0; i < nextGroupId; i++) {
            require(keccak256(bytes(groups[i].cid)) != keccak256(bytes(cid)), "Group with this CID already exists");
            // require(
            //     keccak256(abi.encodePacked(groups[i].name)) != keccak256(abi.encodePacked(name)),
            //     "Group with this name already exists"
            // );
        }

        groups[nextGroupId].name = name;
        groups[nextGroupId].cid = cid;
        _setupRole(_getGroupAdminRole(nextGroupId), msg.sender);

        groups[nextGroupId].members.push(msg.sender);

        for (uint256 i = 0; i < initialMembers.length; i++) {
            require(initialMembers[i] != address(0), "Member address cannot be zero");
            require(!isMemberOfGroup(nextGroupId, initialMembers[i]), "Duplicate member");
            groups[nextGroupId].members.push(initialMembers[i]);
            userGroups[initialMembers[i]].push(nextGroupId);
        }

        emit GroupCreated(nextGroupId, cid, msg.sender);
        nextGroupId++;
        return nextGroupId - 1;
    }

    // Add a safeguard against orphaning a group
    function changeAdmin(uint256 groupId, address newAdmin) external groupExists(groupId) onlyGroupAdmin(groupId) {
        require(newAdmin != address(0), "New admin cannot be the zero address");
        _setupRole(_getGroupAdminRole(groupId), newAdmin);
        _revokeRole(_getGroupAdminRole(groupId), msg.sender);
        emit AdminChanged(groupId, newAdmin, msg.sender);
    }

    function addMember(uint256 groupId, address newMember) public groupExists(groupId) onlyGroupAdmin(groupId) {
        require(newMember != address(0), "Member address cannot be zero");
        require(!isMemberOfGroup(groupId, newMember), "Member already exists");
        groups[groupId].members.push(newMember);
        userGroups[newMember].push(groupId); // Add the group to the user's groups
        emit UserJoinedGroup(groupId, newMember);
    }

    function removeMember(uint256 groupId, address member) public {
        require(isMemberOfGroup(groupId, member), "Member does not exist");
        for (uint256 i = 0; i < groups[groupId].members.length; i++) {
            if (groups[groupId].members[i] == member) {
                groups[groupId].members[i] = groups[groupId].members[groups[groupId].members.length - 1];
                groups[groupId].members.pop();
                break;
            }
        }
        // Remove the group from the user's groups
        uint256[] storage memberGroups = userGroups[member];
        for (uint256 i = 0; i < memberGroups.length; i++) {
            if (memberGroups[i] == groupId) {
                memberGroups[i] = memberGroups[memberGroups.length - 1];
                memberGroups.pop();
                break;
            }
        }
        emit UserLeftGroup(groupId, member);
    }

    function leaveGroup(uint256 groupId) external groupExists(groupId) {
        require(!hasRole(_getGroupAdminRole(groupId), msg.sender), "Group admin cannot leave their own group");
        removeMember(groupId, msg.sender);
    }

    function isMemberOfGroup(uint256 groupId, address user) public view groupExists(groupId) returns (bool) {
        for (uint256 i = 0; i < groups[groupId].members.length; i++) {
            if (groups[groupId].members[i] == user) {
                return true;
            }
        }
        return false;
    }

    function addMembers(uint256 groupId, address[] calldata newMembers)
        external
        groupExists(groupId)
        onlyGroupAdmin(groupId)
    {
        require(newMembers.length <= batchLimit, "Too many members to add at once");
        for (uint256 i = 0; i < newMembers.length; i++) {
            addMember(groupId, newMembers[i]);
        }
    }

    function removeMembers(uint256 groupId, address[] calldata members)
        external
        groupExists(groupId)
        onlyGroupAdmin(groupId)
    {
        for (uint256 i = 0; i < members.length; i++) {
            removeMember(groupId, members[i]);
        }
    }

    function getGroupsOfUser(address user) public view returns (uint256[] memory) {
        return userGroups[user];
    }

    function updateGroupCID(uint256 groupId, string memory newCID)
        external
        groupExists(groupId)
        onlyGroupAdmin(groupId)
    {
        require(bytes(newCID).length > 0, "CID cannot be an empty string");
        string memory oldCID = groups[groupId].cid;
        groups[groupId].cid = newCID;
        emit CIDUpdated(groupId, newCID, oldCID);
    }

    function updateGroupName(uint256 groupId, string memory newName)
        external
        groupExists(groupId)
        onlyGroupAdmin(groupId)
    {
        require(bytes(newName).length > 0, "Name cannot be an empty string");
        string memory oldName = groups[groupId].name;
        groups[groupId].name = newName;
        emit GroupNameUpdated(groupId, newName, oldName);
    }

    function getGroupInfo(uint256 groupId) external view returns (string memory, string memory) {
        return (groups[groupId].name, groups[groupId].cid);
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

    function getGroupMemberCount(uint256 groupId) public view returns (uint256) {
        return groups[groupId].members.length;
    }

    function getGroupMembers(uint256 groupId) public view returns (address[] memory) {
        return groups[groupId].members;
    }
}
