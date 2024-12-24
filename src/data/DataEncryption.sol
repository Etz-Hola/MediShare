// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title DataEncryption
 * @dev Manages encryption keys and access control for medical records
 * Implements on-chain key management and access control
 */
contract DataEncryption is AccessControl, ReentrancyGuard {
    // Struct to store encryption key data
    struct EncryptionKey {
        bytes publicKey;     // Public key for encryption
        uint256 version;     // Key version number
        bool isActive;       // Whether the key is currently active
        uint256 createdAt;   // Timestamp when the key was created
        uint256 expiresAt;   // Timestamp when the key expires (0 for no expiry)
    }

    // Mapping of user addresses to their encryption keys
    mapping(address => EncryptionKey[]) public userEncryptionKeys;
    
    // Mapping to track shared encryption keys
    mapping(address => mapping(address => uint256)) public sharedKeyIndexes;

    // Events
    event KeyRegistered(address indexed user, uint256 version, uint256 expiresAt);
    event KeyShared(address indexed from, address indexed to, uint256 keyIndex);
    event KeyRevoked(address indexed user, uint256 version);
    event EmergencyKeyGenerated(address indexed forUser, address indexed emergencyProvider);

    /**
     * @dev Constructor
     */
    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /**
     * @dev Register a new encryption key for a user
     * @param publicKey Public key data
     * @param expiryDuration Duration in seconds until the key expires (0 for no expiry)
     */
    function registerEncryptionKey(
        bytes memory publicKey,
        uint256 expiryDuration
    ) 
        external 
        nonReentrant 
    {
        require(publicKey.length > 0, "Invalid public key");
        
        uint256 version = userEncryptionKeys[msg.sender].length + 1;
        uint256 expiresAt = expiryDuration > 0 ? block.timestamp + expiryDuration : 0;

        EncryptionKey memory newKey = EncryptionKey({
            publicKey: publicKey,
            version: version,
            isActive: true,
            createdAt: block.timestamp,
            expiresAt: expiresAt
        });

        userEncryptionKeys[msg.sender].push(newKey);
        
        emit KeyRegistered(msg.sender, version, expiresAt);
    }

    /**
     * @dev Share an encryption key with another user
     * @param to Address to share the key with
     * @param keyIndex Index of the key to share
     */
    function shareKey(address to, uint256 keyIndex) 
        external 
        nonReentrant 
    {
        require(to != address(0), "Invalid recipient address");
        require(keyIndex < userEncryptionKeys[msg.sender].length, "Invalid key index");
        require(userEncryptionKeys[msg.sender][keyIndex].isActive, "Key is not active");

        if (userEncryptionKeys[msg.sender][keyIndex].expiresAt > 0) {
            require(
                block.timestamp < userEncryptionKeys[msg.sender][keyIndex].expiresAt,
                "Key has expired"
            );
        }

        sharedKeyIndexes[msg.sender][to] = keyIndex;
        
        emit KeyShared(msg.sender, to, keyIndex);
    }

    /**
     * @dev Get the latest active encryption key for a user
     * @param user Address of the user
     * @return public key bytes and version number
     */
    function getActiveKey(address user) 
        external 
        view 
        returns (bytes memory, uint256) 
    {
        EncryptionKey[] storage keys = userEncryptionKeys[user];
        
        for (uint256 i = keys.length; i > 0; i--) {
            EncryptionKey storage key = keys[i - 1];
            if (key.isActive && (key.expiresAt == 0 || block.timestamp < key.expiresAt)) {
                return (key.publicKey, key.version);
            }
        }
        
        revert("No active key found");
    }

    /**
     * @dev Generate an emergency access key for a user
     * @param forUser Address of the user requiring emergency access
     * @param emergencyProvider Address of the emergency healthcare provider
     * @param duration Duration for which the emergency key is valid
     */
    function generateEmergencyKey(
        address forUser,
        address emergencyProvider,
        uint256 duration
    ) 
        external 
        onlyRole(DEFAULT_ADMIN_ROLE)
        nonReentrant 
    {
        require(forUser != address(0), "Invalid user address");
        require(emergencyProvider != address(0), "Invalid provider address");
        require(duration > 0, "Duration must be positive");

        // Implementation would generate and store emergency access key
        // This would typically involve complex cryptographic operations
        // that would be handled off-chain with only the results stored here

        emit EmergencyKeyGenerated(forUser, emergencyProvider);
    }
}