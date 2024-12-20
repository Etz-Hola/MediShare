// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title IDataRegistry
 * @dev Interface for the DataRegistry contract
 */
interface IDataRegistry {
    // Events
    event RecordCreated(bytes32 indexed recordId, address indexed owner, string ipfsHash);
    event AccessGranted(bytes32 indexed recordId, address indexed grantee);
    event AccessRevoked(bytes32 indexed recordId, address indexed grantee);
    event EmergencyAccessEnabled(bytes32 indexed recordId, uint256 expiryTime);

    // Core functions
    function createRecord(bytes32 recordId, string memory ipfsHash) external;
    function grantAccess(bytes32 recordId, address grantee) external;
    function revokeAccess(bytes32 recordId, address grantee) external;
    function enableEmergencyAccess(bytes32 recordId, uint256 duration) external;
}

// Additional contract files (MediToken.sol, RewardsEngine.sol, etc.) would follow 
// the same pattern...