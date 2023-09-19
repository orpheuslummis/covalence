// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

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
        bool hasVoted;
    }

    struct Round {
        bool done;
    }

    enum Methodology {linearCombination}

    Member[] public members;
    mapping(address => Votes) private votes;
    EvalDimensions private evalDimensions;
    mapping(address => uint256) public resultingShares;
    Round public round;
    mapping(address => uint256) memberIndex;
    Methodology public methodology;

    event RoundReadyToEnd();
    event NewRoundStarted();
    event NewMembersSet();
    event NewDimensionsSet();

    constructor() {
        round.done = true;
    }

    function setMembers(Member[] memory _members) public onlyOwner {
        delete members;
        for (uint256 i = 0; i < _members.length; i++) {
            members.push(_members[i]);
            memberIndex[_members[i].wallet] = i;
        }
        emit NewMembersSet();
    }

    function getMembers() public view returns (Member[] memory) {
        return members;
    }

    function setDimensions(string[] memory dimensionNames, uint256[] memory weights) public onlyOwner {
        require(dimensionNames.length == weights.length, "Dimension names and weights length mismatch");

        delete evalDimensions.name;
        delete evalDimensions.weight;

        for (uint256 i = 0; i < dimensionNames.length; i++) {
            evalDimensions.name.push(dimensionNames[i]);
            evalDimensions.weight.push(weights[i]);
        }
        emit NewDimensionsSet();
    }

    function getEvalDimensions() public view returns (string[] memory, uint256[] memory) {
        return (evalDimensions.name, evalDimensions.weight);
    }

    function isRoundDone() public view returns (bool) {
        return round.done;
    }

    function startRound() public onlyOwner {
        require(evalDimensions.name.length > 0, "Dimensions must be set before starting a round");
        for (uint256 i = 0; i < members.length; i++) {
            delete votes[members[i].wallet];
            resultingShares[members[i].wallet] = 0;
        }
        round.done = false;
        emit NewRoundStarted();
    }

    function endRound() public onlyOwner {
        round.done = true;
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

    /**
     * Allows a member to vote in the current round.
     * The member submits their scores for each other member in the form of a 2D array.
     * The length of the outer array should be one less than the total number of members (excluding the voter).
     * The length of each inner array should match the number of evaluation dimensions.
     * Each score in the inner array corresponds to the voter's score for a particular member on a particular dimension.
     * After voting, the member's vote status is updated to prevent them from voting again in the same round.
     * Emits a RoundReadyToEnd event after a successful vote.
     */
    function vote(uint256[][] memory scores) public {
        require(isMember(msg.sender), "Only members can vote");
        require(!round.done, "Round is not open");
        require(votes[msg.sender].members.length == 0, "Member has already voted");
        require(!votes[msg.sender].hasVoted, "Member has already voted");
        require(scores.length == (members.length - 1), "Scores array should be the number of other members.");

        for (uint256 i = 0; i < scores.length; i++) {
            require(
                scores[i].length == evalDimensions.name.length,
                "Inner scores array and evalDimensions must have the same length."
            );
        }

        uint256 scoreIndex = 0;
        for (uint256 i = 0; i < members.length; i++) {
            if (members[i].wallet != msg.sender) {
                votes[msg.sender].members.push(members[i].wallet);
                votes[msg.sender].scores.push(scores[scoreIndex]);
                scoreIndex++;
            }
        }
        votes[msg.sender].hasVoted = true;
        emit RoundReadyToEnd();
    }

    function getVotesForMember(address _member) public view returns (address[] memory, uint256[][] memory) {
        return (votes[_member].members, votes[_member].scores);
    }

    function computeRound() public {
        require(members.length > 0, "No members to compute");
        require(round.done, "Round is not yet done");
        if (methodology == Methodology.linearCombination) {
            methodologyLinearCombination();
        } else {
            // TODO
        }
    }

    // compute shares of each members
    // shares total 100%
    // it is considering the scores of each members along the weighted dimensions
    function methodologyLinearCombination() private {
        uint256 totalScore = 0;
        mapping(address => uint256) storage memberScores = resultingShares;

        // Resetting individual member scores
        for (uint256 i = 0; i < members.length; i++) {
            address memberWallet = members[i].wallet;
            memberScores[memberWallet] = 0;
        }

        // Calculating individual member scores
        for (uint256 i = 0; i < members.length; i++) {
            address memberWallet = members[i].wallet;

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

        // Normalizing individual member scores to make up 100%
        uint256 remainingPercentage = 100;
        address lastMemberWallet = members[members.length - 1].wallet;

        for (uint256 i = 0; i < members.length - 1; i++) {
            address memberWallet = members[i].wallet;
            uint256 normalizedShare = (memberScores[memberWallet] * 100) / totalScore;

            resultingShares[memberWallet] = normalizedShare;
            remainingPercentage -= normalizedShare;
        }

        // To ensure total percentage equals 100%, allocate the remaining percentage to the last member.
        resultingShares[lastMemberWallet] = remainingPercentage;
    }
}
