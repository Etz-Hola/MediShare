// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";
import "lib/openzeppelin-contracts/contracts/security/Pausable.sol";
import "lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";
import "../interfaces/IDataRegistry.sol";
import "../interfaces/IMediToken.sol";
import "../interfaces/IRewardsEngine.sol";

/**
 * @title HealthcareHub
 * @dev Main contract orchestrating the healthcare data exchange platform
 * Manages system-wide operations, access control, and integration of core components
 */
contract HealthcareHub is AccessControl, Pausable, ReentrancyGuard {
    // Role definitions
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant PROVIDER_ROLE = keccak256("PROVIDER_ROLE");
    bytes32 public constant RESEARCHER_ROLE = keccak256("RESEARCHER_ROLE");

    // Core contract interfaces
    IDataRegistry public dataRegistry;
    IMediToken public mediToken;
    IRewardsEngine public rewardsEngine;

    // Events
    event ProviderRegistered(address indexed provider);
    event ResearcherRegistered(address indexed researcher);
    event SystemPaused(address indexed admin);
    event SystemUnpaused(address indexed admin);

    /**
     * @dev Constructor to initialize the Healthcare Hub
     * @param _dataRegistry Address of the DataRegistry contract
     * @param _mediToken Address of the MediToken contract
     * @param _rewardsEngine Address of the RewardsEngine contract
     */
    constructor(
        address _dataRegistry,
        address _mediToken,
        address _rewardsEngine
    ) {
        require(_dataRegistry != address(0), "Invalid DataRegistry address");
        require(_mediToken != address(0), "Invalid MediToken address");
        require(_rewardsEngine != address(0), "Invalid RewardsEngine address");

        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(ADMIN_ROLE, msg.sender);
        
        dataRegistry = IDataRegistry(_dataRegistry);
        mediToken = IMediToken(_mediToken);
        rewardsEngine = IRewardsEngine(_rewardsEngine);
    }

    /**
     * @dev Register a new healthcare provider
     * @param provider Address of the provider to register
     */
    function registerProvider(address provider) 
        external 
        onlyRole(ADMIN_ROLE)
        whenNotPaused 
    {
        require(provider != address(0), "Invalid provider address");
        require(!hasRole(PROVIDER_ROLE, provider), "Provider already registered");

        grantRole(PROVIDER_ROLE, provider);
        emit ProviderRegistered(provider);
    }

    /**
     * @dev Register a new researcher
     * @param researcher Address of the researcher to register
     */
    function registerResearcher(address researcher) 
        external 
        onlyRole(ADMIN_ROLE)
        whenNotPaused 
    {
        require(researcher != address(0), "Invalid researcher address");
        require(!hasRole(RESEARCHER_ROLE, researcher), "Researcher already registered");

        grantRole(RESEARCHER_ROLE, researcher);
        emit ResearcherRegistered(researcher);
    }

    // Emergency controls
    function pause() external onlyRole(ADMIN_ROLE) {
        _pause();
        emit SystemPaused(msg.sender);
    }

    function unpause() external onlyRole(ADMIN_ROLE) {
        _unpause();
        emit SystemUnpaused(msg.sender);
    }
}
