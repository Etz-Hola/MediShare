// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title MedicalRecord
 * @dev Defines the structure and operations for medical records
 */
contract MedicalRecord {
    struct Record {
        bytes32 id;              // Unique identifier for the record
        address owner;           // Patient address
        string encryptedData;    // IPFS hash of encrypted medical data
        uint256 timestamp;       // Creation timestamp
        address provider;        // Healthcare provider who created the record
        RecordType recordType;   // Type of medical record
        bool isActive;           // Whether the record is active
    }

    enum RecordType {
        General,
        Laboratory,
        Imaging,
        Prescription,
        Surgery,
        Emergency
    }

    // Events for record lifecycle
    event RecordCreated(bytes32 indexed id, address indexed owner, address indexed provider);
    event RecordUpdated(bytes32 indexed id, address indexed updater);
    event RecordDeactivated(bytes32 indexed id);

    // Additional implementation...
}