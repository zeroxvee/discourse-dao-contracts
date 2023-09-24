pragma solidity ^0.8.19;

import "./MyERC721.sol";
import "./Treasury.sol";

contract DiscourseDAO {
    DiscourseDAOTokenERC721 public daoToken;
    Treasury public treasury;

    struct Proposal {
        string title;
        string description;
        int256 votes;
        address proposer;
        uint256 balance;
        uint256 goal;
    }

    Proposal[] public proposals;

    constructor(address _erc721, address _treasury) {
        // 0x5a87068218B8D8659D26fa67D9502093B4fA5FB1
        // method 0x33818997 purchase()
        daoToken = DiscourseDAOTokenERC721(_erc721);
    }

    function createProposal(
        string memory _title,
        string memory _description,
        uint256 _goal
    ) public {
        Proposal memory newProposal = Proposal({
            title: _title,
            description: _description,
            votes: 0,
            proposer: msg.sender,
            balance: 0,
            goal: _goal
        });
        proposals.push(newProposal);
    }

    function vote(uint256 _proposalId, bool _approve) public {
        require(
            daoToken.balanceOf(msg.sender) > 0,
            "Only DAO members can vote"
        );

        if (_approve) {
            proposals[_proposalId].votes++;
        } else {
            proposals[_proposalId].votes--;
        }
    }

    function fundProposal(uint256 _proposalId) public payable {
        require(msg.value > 0, "Zero value not allowed");

        Proposal storage proposal = proposals[_proposalId];
        proposal.balance += msg.value;
    }
}
