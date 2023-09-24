// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

/*
Covalence is a decentralized platform for managing group evaluations and value distribution.
This contract enables groups to form, each capable of conducting independent evaluation rounds based on flexible evaluation methodologies.

Group Management: Each group is controlled by an admin and consists of multiple members. The admin manages the evaluation rounds within the group.

Evaluation Methodologies: Groups can employ various evaluation methodologies, currently including "LinearCombination" and other methodologies to be decided.

Evaluation Dimensions: The specific evaluation criteria, termed 'evalDimensions,' are flexible and customizable per each group's chosen methodology.

Round Management: Groups can initiate, conduct, and complete evaluation rounds, which take member evaluations and compute a distribution of values.

Future Features:
- Introduce a composable language for custom evaluation methodologies.
- Provide template methodologies for common evaluation scenarios.
*/

import "@openzeppelin/contracts/access/Ownable.sol";
import "./GroupManagement.sol";

contract Covalence is Ownable, GroupManagement {
    struct MemberData {
        string name;
    }

    struct EvalDimensions {
        string[] names;
        uint256[] weights;
    }

    enum EvalMethodology {
        LinearCombination,
        TBD
    }

    enum RoundStatus {
        Closed,
        Open,
        Completed
    }

    struct Round {
        mapping(address => uint256[][]) scores; // scores indexed by member address
        mapping(address => bool) memberHasEvaluated;
        mapping(address => uint256) resultDistribution;
        RoundStatus status;
    }

    struct CovalenceGroup {
        uint256 groupId;
        EvalMethodology methodology;
        EvalDimensions evalDimensions;
        Round[] rounds;
    }

    mapping(uint256 => CovalenceGroup) covalenceGroups;

    event EvalDimensionsUpdated(uint256 groupId);
    event EvalMethodologyUpdated(uint256 groupId);
    event RoundOpen(uint256 groupId, uint256 roundNumber);
    event RoundSet(uint256 groupId, uint256 roundNumber);
    event RoundDimensionsSet(uint256 groupId, uint256 roundNumber);
    event RoundStarted(uint256 groupId, uint256 roundNumber, uint256 memberCount, uint256 dimensionCount);
    event RoundReadyToEnd(uint256 groupId, uint256 roundNumber);
    event RoundEnded(uint256 groupId, uint256 roundNumber, RoundStatus status);

    modifier isRoundOpen(uint256 groupId) {
        require(
            covalenceGroups[groupId].rounds.length > 0
                && covalenceGroups[groupId].rounds[covalenceGroups[groupId].rounds.length - 1].status == RoundStatus.Open,
            "No round is open"
        );
        _;
    }

    modifier isRoundClosed(uint256 groupId) {
        require(
            covalenceGroups[groupId].rounds.length == 0
                || covalenceGroups[groupId].rounds[covalenceGroups[groupId].rounds.length - 1].status != RoundStatus.Open,
            "A round is already open"
        );
        _;
    }

    function setMethodology(uint256 groupId, EvalMethodology newMethodology) external onlyGroupAdmin(groupId) {
        covalenceGroups[groupId].methodology = newMethodology;
        emit EvalMethodologyUpdated(groupId);
    }

    function setDimensions(uint256 groupId, string[] memory dimensionNames, uint256[] memory weights)
        public
        onlyGroupAdmin(groupId)
    {
        require(dimensionNames.length == weights.length, "Dimension names and weights length mismatch");
        covalenceGroups[groupId].evalDimensions.names = dimensionNames;
        covalenceGroups[groupId].evalDimensions.weights = weights;
        emit EvalDimensionsUpdated(groupId);
    }

    function getRoundStatus(uint256 groupId, uint256 roundNumber) public view returns (RoundStatus) {
        return covalenceGroups[groupId].rounds[roundNumber].status;
    }

    function startRound(uint256 groupId) external onlyGroupAdmin(groupId) isRoundClosed(groupId) {
        require(getGroupMemberCount(groupId) > 0, "No members to participate");
        require(covalenceGroups[groupId].evalDimensions.names.length > 0, "Evaluation dimensions not set");

        covalenceGroups[groupId].rounds.push();
        Round storage newRound = covalenceGroups[groupId].rounds[covalenceGroups[groupId].rounds.length - 1];
        newRound.status = RoundStatus.Open;

        emit RoundStarted(
            groupId,
            covalenceGroups[groupId].rounds.length - 1,
            getGroupMemberCount(groupId),
            covalenceGroups[groupId].evalDimensions.names.length
        );
    }

    function allMembersEvaluated(uint256 groupId, uint256 roundNumber) private view returns (bool) {
        address[] memory groupMembers = getGroupMembers(groupId);
        for (uint256 i = 0; i < groupMembers.length; i++) {
            if (!covalenceGroups[groupId].rounds[roundNumber].memberHasEvaluated[groupMembers[i]]) {
                return false;
            }
        }
        return true;
    }

    function endRound(uint256 groupId) external onlyGroupAdmin(groupId) isRoundOpen(groupId) {
        uint256 roundNumber = covalenceGroups[groupId].rounds.length - 1;
        require(allMembersEvaluated(groupId, roundNumber), "Not all members have evaluated.");

        Round storage currentRound = covalenceGroups[groupId].rounds[roundNumber];

        if (covalenceGroups[groupId].methodology == EvalMethodology.LinearCombination) {
            methodologyLinearCombination(groupId, roundNumber);
        } else {
            revert("Invalid methodology");
        }

        currentRound.status = RoundStatus.Completed;

        emit RoundEnded(groupId, covalenceGroups[groupId].rounds.length - 1, currentRound.status);
    }

    /**
     * The member submits scores for each member, including themselves, in the form of a 2D array.
     * The length of the outer array should match the total number of members.
     * The length of each inner array should match the number of evaluation dimensions.
     * Each score in the inner array corresponds to the evaluator's score for a particular member on a particular dimension.
     * After voting, the member's evaluation status is updated to prevent them from scoring again in the same round.
     * Emits a RoundReadyToEnd event after a successful evaluation if all members have evaluated.
     */
    function eval(uint256 groupId, uint256 roundNumber, uint256[][] memory scores) public {
        require(isMemberOfGroup(groupId, msg.sender), "Only members can evaluate");
        require(covalenceGroups[groupId].rounds[roundNumber].status == RoundStatus.Open, "Round is not open");
        require(
            !covalenceGroups[groupId].rounds[roundNumber].memberHasEvaluated[msg.sender], "Member has already evaluated"
        );
        require(scores.length == getGroupMemberCount(groupId), "Scores array should match the number of members.");

        // Ensure that the length of each inner array matches the number of evaluation dimensions.
        for (uint256 i = 0; i < scores.length; i++) {
            require(
                scores[i].length == covalenceGroups[groupId].evalDimensions.names.length,
                "Inner scores array and evalDimensions must have the same length."
            );
        }

        for (uint256 i = 0; i < getGroupMemberCount(groupId); i++) {
            covalenceGroups[groupId].rounds[roundNumber].scores[msg.sender][i] = scores[i];
        }

        covalenceGroups[groupId].rounds[roundNumber].memberHasEvaluated[msg.sender] = true;

        if (allMembersEvaluated(groupId, roundNumber)) {
            emit RoundReadyToEnd(groupId, roundNumber);
        }
    }

    function getEvalsOfMember(uint256 groupId, uint256 roundNumber, address _member)
        public
        view
        returns (uint256[][] memory)
    {
        return covalenceGroups[groupId].rounds[roundNumber].scores[_member];
    }

    function getEvalDimensions(uint256 groupId) public view returns (string[] memory, uint256[] memory) {
        return (covalenceGroups[groupId].evalDimensions.names, covalenceGroups[groupId].evalDimensions.weights);
    }

    function methodologyLinearCombination(uint256 groupId, uint256 roundNumber) private {
        uint256 totalScore = 0;
        uint256[] memory individualScores = new uint256[](getGroupMemberCount(groupId));

        uint256 evalDimensionWeightsSum = 0;
        for (uint256 i = 0; i < covalenceGroups[groupId].evalDimensions.weights.length; i++) {
            evalDimensionWeightsSum += covalenceGroups[groupId].evalDimensions.weights[i];
        }
        require(evalDimensionWeightsSum > 0, "Sum of dimension weights must be greater than zero.");

        // Accumulate individual scores
        for (uint256 i = 0; i < getGroupMemberCount(groupId); i++) {
            address memberWallet = getGroupMembers(groupId)[i];
            uint256 individualScore = 0;

            for (uint256 j = 0; j < getGroupMemberCount(groupId); j++) {
                for (uint256 k = 0; k < covalenceGroups[groupId].evalDimensions.weights.length; k++) {
                    uint256 dimensionWeight = covalenceGroups[groupId].evalDimensions.weights[k];
                    uint256 memberScore = covalenceGroups[groupId].rounds[roundNumber].scores[memberWallet][j][k];
                    individualScore += (memberScore * dimensionWeight) / evalDimensionWeightsSum;
                }
            }

            individualScores[i] = individualScore;
            totalScore += individualScore;
        }

        // Safety check for division by zero
        require(totalScore > 0, "Total score must be greater than zero.");

        // Compute shares
        for (uint256 i = 0; i < getGroupMemberCount(groupId); i++) {
            address memberWallet = getGroupMembers(groupId)[i];
            uint256 share = (individualScores[i] * 1e18) / totalScore; // Fixed-point arithmetic for more precision
            covalenceGroups[groupId].rounds[roundNumber].resultDistribution[memberWallet] = share;
        }
    }

    struct AddressToUintPair {
        address key;
        uint256 value;
    }

    function getRoundResult(uint256 groupId, uint256 roundNumber) external view returns (AddressToUintPair[] memory) {
        require(covalenceGroups[groupId].rounds[roundNumber].status == RoundStatus.Completed, "Round not yet ended");

        address[] memory groupMembers = getGroupMembers(groupId);
        AddressToUintPair[] memory results = new AddressToUintPair[](groupMembers.length);

        for (uint256 i = 0; i < groupMembers.length; i++) {
            results[i] = AddressToUintPair(
                groupMembers[i], covalenceGroups[groupId].rounds[roundNumber].resultDistribution[groupMembers[i]]
            );
        }

        return results;
    }

    function getMemberEvaluation(uint256 groupId, uint256 roundNumber, address member)
        external
        view
        returns (uint256[] memory)
    {
        require(covalenceGroups[groupId].rounds[roundNumber].memberHasEvaluated[member], "Member did not evaluate");
        uint256 index = findMemberIndex(groupId, member);
        return covalenceGroups[groupId].rounds[roundNumber].scores[member][index];
    }

    function findMemberIndex(uint256 groupId, address member) private view returns (uint256) {
        address[] memory groupMembers = getGroupMembers(groupId);
        for (uint256 i = 0; i < groupMembers.length; i++) {
            if (groupMembers[i] == member) {
                return i;
            }
        }
        revert("Member not found");
    }
}
