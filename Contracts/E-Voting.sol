// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Voting {
    struct Voter {
        bool voted;
        uint8 vote;
        bool eligible;
    }

    struct Proposal {
        string name;
        uint voteCount;
    }

    address public owner;
    mapping(address => Voter) public voters;
    Proposal[] public proposals;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this.");
        _;
    }

    modifier hasNotVoted() {
        require(!voters[msg.sender].voted, "Already voted.");
        _;
    }

    constructor(string[] memory proposalNames) {
        owner = msg.sender;
        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    function registerVoter(address voter) public onlyOwner {
        require(!voters[voter].voted, "Voter has already voted.");
        voters[voter].eligible = true;
    }

    function vote(uint8 proposalIndex) public hasNotVoted {
        require(voters[msg.sender].eligible, "Not eligible to vote.");
        
        voters[msg.sender].voted = true;
        voters[msg.sender].vote = proposalIndex;

        proposals[proposalIndex].voteCount += 1;
    }

    function winningProposal() public view returns (uint8 _winningProposal) {
        uint256 winningVoteCount = 0;
        for (uint8 i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                _winningProposal = i;
            }
        }
    }

    function getProposalName(uint8 index) public view returns (string memory) {
        return proposals[index].name;
    }

    function getVoteCount(uint8 index) public view returns (uint) {
        return proposals[index].voteCount;
    }

    function totalProposals() public view returns (uint) {
        return proposals.length;
    }
}
