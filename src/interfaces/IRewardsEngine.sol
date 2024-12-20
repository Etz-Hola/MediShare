// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title IRewardsEngine
 * @dev Interface for the RewardsEngine contract
 */
interface IRewardsEngine {
    function distributeReward(address patient, uint256 amount) external;
    function getPatientContributions(address patient) external view returns (uint256);
}