// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import {Test} from "forge-std/Test.sol";
import {Covalence} from "../src/Covalence.sol";

/*

contract CovalenceTestFixture {
    function setupGroup(Covalence covalence) internal {
        address[] memory initialMembers = new address[](2);
        initialMembers[0] = address(0xAbc);
        initialMembers[1] = address(0xDef);
        covalence.createGroup("Test Group", "QmTestCID", initialMembers);

        string[] memory names = new string[](2);
        uint256[] memory weights = new uint256[](2);
        names[0] = "Quality";
        names[1] = "Speed";
        weights[0] = 3;
        weights[1] = 1;
        covalence.setEvalDimensions(1, names, weights);
    }
}

contract CovalenceTest is Test {
    address public owner;
    Covalence public covalence;

    function setUp() public {
        owner = msg.sender;
        covalence = new Covalence();
    }

    function test_SetDimensions() public {
        setupGroup();

        (string[] memory fetchedNames, uint256[] memory fetchedWeights) = covalence.getEvalDimensions(1);
        assertEq(fetchedNames[0], "Quality");
        assertEq(fetchedNames[1], "Speed");
        assertEq(fetchedWeights[0], 3);
        assertEq(fetchedWeights[1], 1);
    }

    function test_StartEndRound() public {
        setupGroup();

        covalence.startRound(1);
        assertEq(covalence.getRoundStatus(1), Covalence.RoundStatus.Open, "Round status is not Open");

        covalence.endRound(1);
        assert(covalence.getRoundStatus(1) == Covalence.RoundStatus.Closed, "Round status is not Closed");
    }

    function test_Vote() public {
        setupGroup();

        covalence.startRound(1);

        uint256[][] memory scoresAlice = new uint256[][](3);
        scoresAlice[0] = new uint256[](2);
        scoresAlice[0][0] = 7;
        scoresAlice[0][1] = 5;
        scoresAlice[1] = new uint256[](2);
        scoresAlice[1][0] = 6;
        scoresAlice[1][1] = 4;
        scoresAlice[2] = new uint256[](2);
        scoresAlice[2][0] = 8;
        scoresAlice[2][1] = 6;

        bool successAlice = true;
        try covalence.eval(1, scoresAlice) {}
        catch {
            successAlice = false;
        }
        assertEq(successAlice, true);

        uint256[][] memory scoresBob = new uint256[][](3);
        scoresBob[0] = new uint256[](2);
        scoresBob[0][0] = 7;
        scoresBob[0][1] = 5;
        scoresBob[1] = new uint256[](2);
        scoresBob[1][0] = 6;
        scoresBob[1][1] = 4;
        scoresBob[2] = new uint256[](2);
        scoresBob[2][0] = 8;
        scoresBob[2][1] = 6;

        bool successBob = true;
        try covalence.eval(1, scoresBob) {}
        catch {
            successBob = false;
        }
        assertEq(successBob, true);

        uint256[][] memory scoresOwner = new uint256[][](3);
        scoresOwner[0] = new uint256[](2);
        scoresOwner[0][0] = 7;
        scoresOwner[0][1] = 5;
        scoresOwner[1] = new uint256[](2);
        scoresOwner[1][0] = 6;
        scoresOwner[1][1] = 4;
        scoresOwner[2] = new uint256[](2);
        scoresOwner[2][0] = 8;
        scoresOwner[2][1] = 6;

        bool successOwner = true;
        try covalence.eval(1, scoresOwner) {}
        catch {
            successOwner = false;
        }
        assertEq(successOwner, true);
    }

    function test_TwoMembersVote() public {
        setupGroup();

        covalence.startRound(1);

        uint256[][] memory scoresAlice = new uint256[][](1);
        scoresAlice[0] = new uint256[](2);
        scoresAlice[0][0] = 7;
        scoresAlice[0][1] = 5;
        covalence.eval(1, scoresAlice);

        // Verify Alice's votes
        uint256[][] memory scoresVotedAlice = covalence.getEvalsOfMember(1, address(0xAbc));
        assertEq(scoresVotedAlice[0][0], 7);
        assertEq(scoresVotedAlice[0][1], 5);

        uint256[][] memory scoresBob = new uint256[][](1);
        scoresBob[0] = new uint256[](2);
        scoresBob[0][0] = 6;
        scoresBob[0][1] = 4;
        covalence.eval(1, scoresBob);

        // Verify Bob's votes
        uint256[][] memory scoresVotedBob = covalence.getEvalsOfMember(1, address(0xDef));
        assertEq(scoresVotedBob[0][0], 6);
        assertEq(scoresVotedBob[0][1], 4);

        assertEq(covalence.hasMemberEvaluated(1, address(0xAbc)), true);
        assertEq(covalence.hasMemberEvaluated(1, address(0xDef)), true);
    }

    function test_ComputeRound() public {
        setupGroup();

        covalence.startRound(1);

        uint256[][] memory scoresAlice = new uint256[][](1);
        scoresAlice[0] = new uint256[](1);
        scoresAlice[0][0] = 2;
        covalence.eval(1, scoresAlice);

        uint256[][] memory scoresBob = new uint256[][](1);
        scoresBob[0] = new uint256[](1);
        scoresBob[0][0] = 4;
        covalence.eval(1, scoresBob);

        covalence.endRound(1);

        // The computation of resulting shares is not part of the Covalence contract anymore.
        // It should be done off-chain or in another contract.
    }

    function test_NonMemberCannotVote() public {
        setupGroup();

        covalence.startRound(1);

        uint256[][] memory scores = new uint256[][](1);
        scores[0] = new uint256[](1);
        scores[0][0] = 5;

        bool success = true;
        try covalence.eval(1, scores) {}
        catch {
            success = false;
        }

        assertEq(success, false);
    }
}

*/
