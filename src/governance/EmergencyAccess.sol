contract EmergencyAccess is AccessControl {
    DataRegistry public dataRegistry;
    
    event EmergencyAccessGranted(bytes32 indexed recordId, address indexed provider);
    
    constructor(address _dataRegistry) {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        dataRegistry = DataRegistry(_dataRegistry);
    }
    
    function grantEmergencyAccess(bytes32 recordId, address provider) external onlyRole(DEFAULT_ADMIN_ROLE) {
        // Implementation for emergency access logic
        emit EmergencyAccessGranted(recordId, provider);
    }
}