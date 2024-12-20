// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

/**
 * @title CustomAccessControl
 * @dev Implements role-based access control for the healthcare platform
 * Manages different roles and their permissions
 */
contract CustomAccessControl is AccessControl, Pausable {
    // Role definitions
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant PROVIDER_ROLE = keccak256("PROVIDER_ROLE");
    bytes32 public constant RESEARCHER_ROLE = keccak256("RESEARCHER_ROLE");
    bytes32 public constant PATIENT_ROLE = keccak256("PATIENT_ROLE");
    bytes32 public constant EMERGENCY_ROLE = keccak256("EMERGENCY_ROLE");

    // Role permission levels (0: lowest, 255: highest)
    mapping(bytes32 => uint8) public rolePermissionLevels;

    // Role timeouts for temporary access
    mapping(address => mapping(bytes32 => uint256)) public roleExpiryTimes;

    // Events
    event RoleGrantedWithTimeout(bytes32 indexed role, address indexed account, uint256 expiryTime);
    event RolePermissionLevelUpdated(bytes32 indexed role, uint8 newLevel);
    event TemporaryAccessExpired(address indexed account, bytes32 indexed role);

    /**
     * @dev Constructor to set up initial roles and permission levels
     */
    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(ADMIN_ROLE, msg.sender);

        // Set up initial permission levels
        rolePermissionLevels[DEFAULT_ADMIN_ROLE] = 255; // Highest level
        rolePermissionLevels[ADMIN_ROLE] = 200;
        rolePermissionLevels[PROVIDER_ROLE] = 150;
        rolePermissionLevels[RESEARCHER_ROLE] = 100;
        rolePermissionLevels[PATIENT_ROLE] = 50;
        rolePermissionLevels[EMERGENCY_ROLE] = 175; // Higher than provider for emergency access
    }

    /**
     * @dev Grant a role with a timeout period
     * @param role Role to grant
     * @param account Address to receive the role
     * @param duration Duration in seconds for which the role is valid
     */
    function grantRoleWithTimeout(
        bytes32 role,
        address account,
        uint256 duration
    ) public onlyRole(getRoleAdmin(role)) {
        require(account != address(0), "Invalid account address");
        require(duration > 0, "Duration must be positive");
        
        grantRole(role, account);
        roleExpiryTimes[account][role] = block.timestamp + duration;
        
        emit RoleGrantedWithTimeout(role, account, roleExpiryTimes[account][role]);
    }

    /**
     * @dev Check if an account has a valid (non-expired) role
     * @param role Role to check
     * @param account Address to check
     * @return bool indicating if the role is valid
     */
    function hasValidRole(bytes32 role, address account) public view returns (bool) {
        if (!hasRole(role, account)) {
            return false;
        }

        uint256 expiryTime = roleExpiryTimes[account][role];
        if (expiryTime == 0) {
            return true; // Permanent role
        }

        return block.timestamp <= expiryTime;
    }

    /**
     * @dev Update permission level for a role
     * @param role Role to update
     * @param newLevel New permission level
     */
    function updateRolePermissionLevel(bytes32 role, uint8 newLevel) 
        external 
        onlyRole(DEFAULT_ADMIN_ROLE) 
    {
        rolePermissionLevels[role] = newLevel;
        emit RolePermissionLevelUpdated(role, newLevel);
    }

    /**
     * @dev Check if one role has higher permissions than another
     * @param role1 First role to compare
     * @param role2 Second role to compare
     * @return bool indicating if role1 has higher permissions than role2
     */
    function hasHigherPermission(bytes32 role1, bytes32 role2) 
        public 
        view 
        returns (bool) 
    {
        return rolePermissionLevels[role1] > rolePermissionLevels[role2];
    }

    /**
     * @dev Revoke expired roles
     * @param account Address to check and revoke expired roles from
     * @param roles Array of roles to check
     */
    function revokeExpiredRoles(address account, bytes32[] memory roles) 
        external 
    {
        for (uint i = 0; i < roles.length; i++) {
            bytes32 role = roles[i];
            if (hasRole(role, account) && 
                roleExpiryTimes[account][role] != 0 && 
                block.timestamp > roleExpiryTimes[account][role]) {
                revokeRole(role, account);
                emit TemporaryAccessExpired(account, role);
            }
        }
    }
}
