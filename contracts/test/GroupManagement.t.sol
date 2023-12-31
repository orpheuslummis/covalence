// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import {GroupManagement} from "../src/GroupManagement.sol";
import {Test} from "forge-std/Test.sol";

contract GroupManagementTest is Test {
    address public owner;
    GroupManagement public groupManagement;

    function setUp() public {
        owner = msg.sender;
        groupManagement = new GroupManagement();
    }

    function test_CreateGroup() public {
        address[] memory initialMembers = new address[](1);
        initialMembers[0] = address(0xAbc);
        uint256 groupId = groupManagement.createGroup("Test Group", "CID", initialMembers);

        (string memory groupName, string memory groupCID) = groupManagement.getGroupInfo(groupId);
        assertEq(groupName, "Test Group");
        assertEq(groupCID, "CID");
        assertEq(groupManagement.getGroupMemberCount(groupId), 2);
    }

    function test_AddMember() public {
        address[] memory initialMembers = new address[](1);
        initialMembers[0] = address(0xAbc);
        uint256 groupId = groupManagement.createGroup("Test Group", "CID", initialMembers);

        groupManagement.addMember(groupId, address(0xDef));
        bool isMember = groupManagement.isMemberOfGroup(groupId, address(0xDef));
        assertTrue(isMember);
        assertEq(groupManagement.getGroupMemberCount(groupId), 3);
    }

    function test_RemoveMember() public {
        address[] memory initialMembers = new address[](2);
        initialMembers[0] = address(0xAbc);
        initialMembers[1] = address(0xDef);
        uint256 groupId = groupManagement.createGroup("Test Group", "CID", initialMembers);

        groupManagement.removeMember(groupId, address(0xDef));
        bool isMember = groupManagement.isMemberOfGroup(groupId, address(0xDef));
        assertFalse(isMember);
        assertEq(groupManagement.getGroupMemberCount(groupId), 2);
    }

    function test_ChangeAdmin() public {
        address[] memory initialMembers = new address[](1);
        initialMembers[0] = address(0xAbc);
        uint256 groupId = groupManagement.createGroup("Test Group", "CID", initialMembers);

        groupManagement.changeAdmin(groupId, address(0xDef));
        bool isAdmin = groupManagement.hasRole(groupManagement.getGroupAdminRole(groupId), address(0xDef));
        assertTrue(isAdmin);
    }

    function testFail_LeaveGroup() public {
        address[] memory initialMembers = new address[](2);
        initialMembers[0] = address(0xAbc);
        initialMembers[1] = address(0xDef);
        uint256 groupId = groupManagement.createGroup("Test Group", "CID", initialMembers);

        // Fails because the group admin cannot leave the group
        groupManagement.leaveGroup(groupId);
    }

    function test_LeaveGroup() public {
        address[] memory initialMembers = new address[](2);
        initialMembers[0] = address(0xAbc);
        initialMembers[1] = address(0xDef);
        uint256 groupId = groupManagement.createGroup("Test Group", "CID", initialMembers);

        assertEq(groupManagement.getGroupMemberCount(groupId), 3);
        vm.prank(initialMembers[0]);
        groupManagement.leaveGroup(groupId);
        bool isMember = groupManagement.isMemberOfGroup(groupId, initialMembers[0]);
        assertFalse(isMember);
        assertEq(groupManagement.getGroupMemberCount(groupId), 2);
    }

    function test_getGroupsOfUser() public {
        address[] memory initialMembers = new address[](1);
        initialMembers[0] = address(0xAbc);
        uint256 groupId1 = groupManagement.createGroup("Test Group 1", "CID1", initialMembers);
        uint256 groupId2 = groupManagement.createGroup("Test Group 2", "CID2", initialMembers);

        uint256[] memory userGroups = groupManagement.getGroupsOfUser(initialMembers[0]);
        assertEq(userGroups.length, 2);
        assertEq(userGroups[0], groupId1);
        assertEq(userGroups[1], groupId2);
    }

    function testFail_CreateGroupWithDuplicateMembers() public {
        address[] memory initialMembers = new address[](2);
        initialMembers[0] = address(0xAbc);
        initialMembers[1] = address(0xAbc);
        groupManagement.createGroup("Test Group", "CID", initialMembers);
    }

    function testFail_CreateGroupWithSameCID() public {
        address[] memory initialMembers = new address[](1);
        initialMembers[0] = address(0xAbc);
        groupManagement.createGroup("Test Group", "CID", initialMembers);
        groupManagement.createGroup("Test Group 2", "CID", initialMembers);
    }

    function testFail_AddZeroAddressMember() public {
        address[] memory initialMembers = new address[](1);
        initialMembers[0] = address(0xAbc);
        uint256 groupId = groupManagement.createGroup("Test Group", "CID", initialMembers);
        groupManagement.addMember(groupId, address(0));
    }

    function testFail_RemoveNonExistentMember() public {
        address[] memory initialMembers = new address[](1);
        initialMembers[0] = address(0xAbc);
        uint256 groupId = groupManagement.createGroup("Test Group", "CID", initialMembers);
        groupManagement.removeMember(groupId, address(0xDef));
    }

    function testFail_ChangeAdminToZeroAddress() public {
        address[] memory initialMembers = new address[](1);
        initialMembers[0] = address(0xAbc);
        uint256 groupId = groupManagement.createGroup("Test Group", "CID", initialMembers);
        groupManagement.changeAdmin(groupId, address(0));
    }

    function testFail_UpdateGroupCIDToEmptyString() public {
        address[] memory initialMembers = new address[](1);
        initialMembers[0] = address(0xAbc);
        uint256 groupId = groupManagement.createGroup("Test Group", "CID", initialMembers);
        groupManagement.updateGroupCID(groupId, "");
    }

    function testFail_UpdateGroupNameToEmptyString() public {
        address[] memory initialMembers = new address[](1);
        initialMembers[0] = address(0xAbc);
        uint256 groupId = groupManagement.createGroup("Test Group", "CID", initialMembers);
        groupManagement.updateGroupName(groupId, "");
    }
}
