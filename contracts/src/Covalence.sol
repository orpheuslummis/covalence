// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Covalence is Ownable {
    struct Member {
        address wallet;
        string name;
    }

    struct EvalDimensions {
        string[] name;
        uint256[] weight;
    }

    struct Votes {
        address[] members;
        uint256[][] scores;
    }

    struct Round {
        bool done;
    }

    Member[] public members;
    mapping(address => Votes) private votes;
    EvalDimensions private evalDimensions;
    mapping(address => uint256) public resultingShares;
    Round public round;

    event RoundReadyToEnd();
    event NewRoundStarted();
    event NewMembersSet();
    event NewDimensionsSet();

    constructor() {
        round.done = true;
    }

    function setMembers(Member[] memory _members) public onlyOwner {
        members = _members;
        emit NewMembersSet();
    }

    function getMembers() public view returns (Member[] memory) {
        return members;
    }

    function setDimensions(string[] memory dimensionNames, uint256[] memory weights) public onlyOwner {
        require(dimensionNames.length == weights.length, "Dimension names and weights length mismatch");
        evalDimensions.name = dimensionNames;
        evalDimensions.weight = weights;
        emit NewDimensionsSet();
    }

    function isRoundDone() public view returns (bool) {
        return round.done;
    }

    function startRound() public onlyOwner {
        for (uint256 i = 0; i < members.length; i++) {
            delete votes[members[i].wallet].members;
            delete votes[members[i].wallet].scores;
            resultingShares[members[i].wallet] = 0;
        }
        round.done = false;
        emit NewRoundStarted();
    }

    function endRound() public onlyOwner {
        round.done = true;
        emit RoundReadyToEnd();
    }

    function vote(uint256[][] memory scores) public {
        require(isMember(msg.sender), "Only members can vote");
        require(!round.done, "Round is not open");
        require(votes[msg.sender].members.length == 0, "Member has already voted");

        for (uint256 i = 0; i < members.length; i++) {
            if (members[i].wallet != msg.sender) {
                votes[msg.sender].members.push(members[i].wallet);
                votes[msg.sender].scores.push(scores[i]);
            }
        }
        emit RoundReadyToEnd();
    }

    function isMember(address member) private view returns (bool) {
        for (uint256 i = 0; i < members.length; i++) {
            if (members[i].wallet == member) {
                return true;
            }
        }
        return false;
    }

    function getEvalDimensions() public view returns (string[] memory, uint256[] memory) {
        return (evalDimensions.name, evalDimensions.weight);
    }

    function getVotesForMember(address _member) public view returns (address[] memory, uint256[][] memory) {
        return (votes[_member].members, votes[_member].scores);
    }

    function computeRound() public {
        require(round.done, "Round is not yet done");
        methodologyLinearCombination();
    }

    function methodologyLinearCombination() private {
        uint256 totalScore = 0;
        mapping(address => uint256) storage memberScores = resultingShares;

        for (uint256 i = 0; i < members.length; i++) {
            address memberWallet = members[i].wallet;
            memberScores[memberWallet] = 0;

            for (uint256 k = 0; k < evalDimensions.weight.length; k++) {
                uint256 dimensionWeight = evalDimensions.weight[k];

                for (uint256 j = 0; j < votes[memberWallet].members.length; j++) {
                    uint256 scoreForDimension = votes[memberWallet].scores[j][k];
                    memberScores[memberWallet] += scoreForDimension * dimensionWeight;
                }
            }
            totalScore += memberScores[memberWallet];
        }

        require(totalScore > 0, "Total score must be greater than zero to avoid division by zero.");

        for (uint256 i = 0; i < members.length; i++) {
            address memberWallet = members[i].wallet;
            resultingShares[memberWallet] = (memberScores[memberWallet] * 100) / totalScore;
        }
    }
}
