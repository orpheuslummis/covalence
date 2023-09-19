// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Covalence} from "../src/Covalence.sol";

contract CovalenceTest is Test {
    Covalence public covalence;

    function setUp() public {
        covalence = new Covalence();
    }

    function test_SetMembers() public {
        Covalence.Member[] memory _members = new Covalence.Member[](2);
        _members[0] = Covalence.Member(address(0xAbc), "Alice");
        _members[1] = Covalence.Member(address(0xDef), "Bob");
        covalence.setMembers(_members);

        Covalence.Member[] memory returnedMembers = covalence.getMembers();
        assertEq(returnedMembers[0].wallet, address(0xAbc));
        assertEq(returnedMembers[1].wallet, address(0xDef));
    }

    function test_SetDimensions() public {
        string[] memory names = new string[](2);
        uint256[] memory weights = new uint256[](2);
        names[0] = "Quality";
        names[1] = "Speed";
        weights[0] = 3;
        weights[1] = 1;
        covalence.setDimensions(names, weights);

        (string[] memory fetchedNames, uint256[] memory fetchedWeights) = covalence.getEvalDimensions();
        assertEq(fetchedNames[0], "Quality");
        assertEq(fetchedNames[1], "Speed");
        assertEq(fetchedWeights[0], 3);
        assertEq(fetchedWeights[1], 1);
    }

    function test_StartEndRound() public {
        covalence.startRound();
        assertEq(covalence.isRoundDone(), false);

        covalence.endRound();
        assertEq(covalence.isRoundDone(), true);
    }

    function test_Vote() public {
        Covalence.Member[] memory _members = new Covalence.Member[](2);
        _members[0] = Covalence.Member(address(0xAbc), "Alice");
        _members[1] = Covalence.Member(address(0xDef), "Bob");
        covalence.setMembers(_members);

        string[] memory names = new string[](1);
        uint256[] memory weights = new uint256[](1);
        names[0] = "Quality";
        weights[0] = 1;
        covalence.setDimensions(names, weights);

        covalence.startRound();

        uint256[][] memory scores = new uint256[][](1);
        scores[0] = new uint256[](1);
        scores[0][0] = 7;
        covalence.vote(scores);

        (address[] memory fetchedMembers, uint256[][] memory fetchedScores) =
            covalence.getVotesForMember(address(0xAbc));
        assertEq(fetchedMembers[0], address(0xDef));
        assertEq(fetchedScores[0][0], 7);
    }

    function test_ComputeRound() public {
        Covalence.Member[] memory _members = new Covalence.Member[](2);
        _members[0] = Covalence.Member(address(0xAbc), "Alice");
        _members[1] = Covalence.Member(address(0xDef), "Bob");
        covalence.setMembers(_members);

        string[] memory names = new string[](1);
        uint256[] memory weights = new uint256[](1);
        names[0] = "Quality";
        weights[0] = 1;
        covalence.setDimensions(names, weights);

        covalence.startRound();
        uint256[][] memory scores = new uint256[][](1);
        scores[0] = new uint256[](1);
        scores[0][0] = 7;
        covalence.vote(scores);

        covalence.endRound();
        covalence.computeRound();

        // TBD
        assertEq(covalence.resultingShares(address(0xAbc)), 11);
        assertEq(covalence.resultingShares(address(0xDef)), 89);
    }

    function test_NonMemberCannotVote() public {
        covalence.startRound();

        uint256[][] memory scores = new uint256[][](1);
        scores[0] = new uint256[](1);
        scores[0][0] = 5;

        bool success = true;
        try covalence.vote(scores) {}
        catch {
            success = false;
        }

        assertEq(success, false);
    }
}
