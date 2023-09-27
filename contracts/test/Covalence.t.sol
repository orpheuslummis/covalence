// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import {Test} from "forge-std/Test.sol";
import {Covalence} from "../src/Covalence.sol";

contract CovalenceTest is Test {
    address public owner;
    Covalence public covalence;

    function setUp() public {
        owner = msg.sender;
        covalence = new Covalence();
    }

    function fixtureGroup() internal returns (uint256) {
        address[] memory initialMembers = new address[](2);
        initialMembers[0] = address(0xAbc);
        initialMembers[1] = address(0xDef);
        uint256 groupId = covalence.createGroup("Test Group", "QmTestCID", initialMembers);
        return groupId;
    }

    function test_SetDimensions() public {
        uint256 groupId = fixtureGroup();

        string[] memory names = new string[](2);
        uint256[] memory weights = new uint256[](2);
        names[0] = "Quality";
        names[1] = "Speed";
        weights[0] = 3;
        weights[1] = 1;
        covalence.setDimensions(groupId, names, weights);

        (string[] memory fetchedNames, uint256[] memory fetchedWeights) = covalence.getEvalDimensions(groupId);
        assertEq(fetchedNames[0], "Quality");
        assertEq(fetchedNames[1], "Speed");
        assertEq(fetchedWeights[0], 3);
        assertEq(fetchedWeights[1], 1);
    }

    function testFail_StartEndRoundWithoutEval() public {
        uint256 groupId = fixtureGroup();

        // need to set dimensions before starting a round
        string[] memory names = new string[](1);
        uint256[] memory weights = new uint256[](1);
        names[0] = "Dimensions1";
        weights[0] = 1;
        covalence.setDimensions(groupId, names, weights);
        uint256 roundId = covalence.startRound(groupId);
        assert(covalence.getRoundStatus(groupId, roundId) == Covalence.RoundStatus.Open);

        // need for all members to evaluate before closing a round, so this will fail
        covalence.endRound(groupId);
    }

    function test_MemberScores() public {
        uint256 groupId = fixtureGroup();

        address[] memory members = covalence.getGroupMembers(groupId);

        // Set dimensions before starting a round
        string[] memory names = new string[](2);
        uint256[] memory weights = new uint256[](2);
        names[0] = "Quality";
        names[1] = "Speed";
        weights[0] = 3;
        weights[1] = 1;
        covalence.setDimensions(groupId, names, weights);

        // Now get the dimensions
        (string[] memory dimensions,) = covalence.getEvalDimensions(groupId);

        uint256 roundId = covalence.startRound(groupId);

        // For each member, including the current member, score each member along all dimensions
        for (uint256 i = 0; i < members.length; i++) {
            uint256[][] memory scores = new uint256[][](members.length);
            for (uint256 j = 0; j < members.length; j++) {
                scores[j] = new uint256[](dimensions.length);
                for (uint256 k = 0; k < dimensions.length; k++) {
                    uint256 score = 1; // replace this with the actual score
                    scores[j][k] = score;
                }
            }

            // Ensure that the scores array is correctly structured before calling the eval function
            require(scores.length == members.length, "Outer scores array length does not match the number of members");
            for (uint256 j = 0; j < scores.length; j++) {
                require(
                    scores[j].length == dimensions.length,
                    "Inner scores array length does not match the number of dimensions"
                );
            }

            // Impersonate the i-th member
            vm.prank(members[i]);

            covalence.eval(groupId, roundId, scores);
        }
    }

    function test_NonMemberCannotVote() public {
        uint256 groupId = fixtureGroup();

        string[] memory names = new string[](1);
        uint256[] memory weights = new uint256[](1);
        names[0] = "Dimensions1";
        weights[0] = 1;
        covalence.setDimensions(groupId, names, weights);
        uint256 roundId = covalence.startRound(groupId);

        uint256[][] memory scores = new uint256[][](2);
        scores[0] = new uint256[](1);
        scores[0][0] = 3;
        scores[1] = new uint256[](1);
        scores[1][0] = 1;

        bool success = true;
        try covalence.eval(groupId, roundId, scores) {}
        catch {
            success = false;
        }

        assertEq(success, false);
    }

    function test_MemberCanVote() public {
        uint256 groupId = fixtureGroup();

        string[] memory names = new string[](1);
        uint256[] memory weights = new uint256[](1);
        names[0] = "Dimensions1";
        weights[0] = 1;
        covalence.setDimensions(groupId, names, weights);

        uint256 roundId = covalence.startRound(groupId);

        uint256[][] memory scores = new uint256[][](3);
        scores[0] = new uint256[](1);
        scores[0][0] = 3;
        scores[1] = new uint256[](1);
        scores[1][0] = 1;
        scores[2] = new uint256[](1);
        scores[2][0] = 2;

        bool success = true;
        try covalence.eval(groupId, roundId, scores) {}
        catch {
            success = false;
        }

        assertEq(success, true);
    }

    function test_RoundStatusAfterVote() public {
        uint256 groupId = fixtureGroup();

        string[] memory names = new string[](1);
        uint256[] memory weights = new uint256[](1);
        names[0] = "Dimensions1";
        weights[0] = 1;
        covalence.setDimensions(groupId, names, weights);
        uint256 roundId = covalence.startRound(groupId);

        uint256[][] memory scores = new uint256[][](3);
        scores[0] = new uint256[](1);
        scores[0][0] = 3;
        scores[1] = new uint256[](1);
        scores[1][0] = 1;
        scores[2] = new uint256[](1);
        scores[2][0] = 2;

        covalence.eval(groupId, roundId, scores);
        Covalence.RoundStatus status = covalence.getRoundStatus(groupId, roundId);

        assertEq(uint256(status), uint256(Covalence.RoundStatus.Open));
    }

    function test_EndRound() public {
        uint256 groupId = fixtureGroup();

        string[] memory names = new string[](1);
        uint256[] memory weights = new uint256[](1);
        names[0] = "Dimensions1";
        weights[0] = 1;
        covalence.setDimensions(groupId, names, weights);
        uint256 roundId = covalence.startRound(groupId);

        uint256[][] memory scores = new uint256[][](3);
        scores[0] = new uint256[](1);
        scores[0][0] = 3;
        scores[1] = new uint256[](1);
        scores[1][0] = 1;
        scores[2] = new uint256[](1);
        scores[2][0] = 2;

        // Each member, including the contract owner, needs to do an 'eval' before ending the round
        address[] memory members = covalence.getGroupMembers(groupId);
        for (uint256 i = 0; i < members.length; i++) {
            vm.prank(members[i]);
            covalence.eval(groupId, roundId, scores);
        }

        covalence.endRound(groupId);
        Covalence.RoundStatus status = covalence.getRoundStatus(groupId, roundId);

        assertEq(uint256(status), uint256(Covalence.RoundStatus.Completed));
    }

    // Double check the inputs and the outputs of this
    function test_GetRoundResult() public {
        uint256 groupId = fixtureGroup();

        string[] memory names = new string[](1);
        uint256[] memory weights = new uint256[](1);
        names[0] = "Dimensions1";
        weights[0] = 1;
        covalence.setDimensions(groupId, names, weights);
        uint256 roundId = covalence.startRound(groupId);

        uint256[][] memory scores = new uint256[][](3);
        scores[0] = new uint256[](1);
        scores[0][0] = 1;
        scores[1] = new uint256[](1);
        scores[1][0] = 1;
        scores[2] = new uint256[](1);
        scores[2][0] = 1;

        // Each member, including the contract owner, needs to do an 'eval' before ending the round
        address[] memory members = covalence.getGroupMembers(groupId);
        for (uint256 i = 0; i < members.length; i++) {
            vm.prank(members[i]);
            covalence.eval(groupId, roundId, scores);
        }

        covalence.endRound(groupId);
        Covalence.AddressToUintPair[] memory results = covalence.getRoundResult(groupId, roundId);

        assertEq(results.length, 3);
        assertEq(results[0].value * 100 / 1e18, 33);
        assertEq(results[1].value * 100 / 1e18, 33);
        assertEq(results[2].value * 100 / 1e18, 33);
    }
}
