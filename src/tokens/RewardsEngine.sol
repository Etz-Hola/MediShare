// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../interfaces/IMediToken.sol";
import "../interfaces/IRewardsEngine.sol";

/**
 * @title RewardsEngine
 * @dev Manages the distribution of rewards for data sharing
 * Implements incentive mechanisms for research participation
 */
contract RewardsEngine is AccessControl {
    MediToken public mediToken;
    mapping(address => uint256) public researchContributions;
    
    event RewardDistributed(address indexed patient, uint256 amount);
    
    constructor(address _mediToken) {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        mediToken = MediToken(_mediToken);
    }
    
    function distributeReward(address patient, uint256 amount) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(patient != address(0), "Invalid patient address");
        mediToken.mint(patient, amount);
        researchContributions[patient] += amount;
        emit RewardDistributed(patient, amount);
    }
}