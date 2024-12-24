// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorSettings.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";

/**
 * @title HealthcareDAO
 * @dev Implements the governance mechanism for the healthcare platform
 * Allows token holders to propose and vote on platform changes
 */
contract HealthcareDAO is 
    Governor, 
    GovernorSettings, 
    GovernorCountingSimple, 
    GovernorVotes,
    GovernorVotesQuorumFraction 
{
    // Governance parameters
    uint256 public constant VOTING_DELAY = 1;      // 1 block delay
    uint256 public constant VOTING_PERIOD = 50400; // About 1 week
    uint256 public constant PROPOSAL_THRESHOLD = 100000 * 10**18; // 100,000 tokens

    constructor(IVotes _token)
        Governor("MediShare DAO")
        GovernorSettings(VOTING_DELAY, VOTING_PERIOD, PROPOSAL_THRESHOLD)
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(4) // 4% quorum
    {}

    // Required overrides from parent contracts
    function votingDelay()
        public
        view
        override(IGovernor, GovernorSettings)
        returns (uint256)
    {
        return super.votingDelay();
    }

    function votingPeriod()
        public
        view
        override(IGovernor, GovernorSettings)
        returns (uint256)
    {
        return super.votingPeriod();
    }

    function quorum(uint256 blockNumber)
        public
        view
        override(IGovernor, GovernorVotesQuorumFraction)
        returns (uint256)
    {
        return super.quorum(blockNumber);
    }

    function proposalThreshold()
        public
        view
        override(Governor, GovernorSettings)
        returns (uint256)
    {
        return super.proposalThreshold();
    }
}
