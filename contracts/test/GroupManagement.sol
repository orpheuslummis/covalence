// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import {Test} from "forge-std/Test.sol";
import {GroupManagement} from "../src/GroupManagement.sol";

contract GroupManagementTest is Test {
    address public owner;
    GroupManagement public groupManagement;

    function setUp() public {
        owner = msg.sender;
        groupManagement = new GroupManagement();
    }

    function test_CreateGroup() public {
        address[] memory initialMembers = new address[](2);
        initialMembers[0] = address(0xAbc);
        initialMembers[1] = address(0xDef);
        groupManagement.createGroup("Test Group", "CID", initialMembers);

        (string memory groupName, bytes32 groupCID) = groupManagement.getGroupInfo(0);
        assertEq(groupName, "Test Group");
        assertEq(groupCID, "CID");
    }

    function test_AddMember() public {
        address[] memory initialMembers = new address[](1);
        initialMembers[0] = address(0xAbc);
        groupManagement.createGroup("Test Group", "CID", initialMembers);

        groupManagement.addMember(0, address(0xDef));
        bool isMember = groupManagement.isMemberOfGroup(0, address(0xDef));
        assertTrue(isMember);
        assertEq(groupManagement.getGroupMemberCount(0), 2);
    }

    function test_RemoveMember() public {
        address[] memory initialMembers = new address[](2);
        initialMembers[0] = address(0xAbc);
        initialMembers[1] = address(0xDef);
        groupManagement.createGroup("Test Group", "CID", initialMembers);

        groupManagement.removeMember(0, address(0xDef));
        bool isMember = groupManagement.isMemberOfGroup(0, address(0xDef));
        assertFalse(isMember);
        assertEq(groupManagement.getGroupMemberCount(0), 1);
    }

    function test_ChangeAdmin() public {
        address[] memory initialMembers = new address[](1);
        initialMembers[0] = address(0xAbc);
        groupManagement.createGroup("Test Group", "CID", initialMembers);

        groupManagement.changeAdmin(0, address(0xDef));
        bool isAdmin = groupManagement.hasRole(groupManagement.getGroupAdminRole(0), address(0xDef));
        assertTrue(isAdmin);
    }
}
