// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "../interfaces/IMediToken.sol";

/**
 * @title MediToken
 * @dev ERC20 token for the healthcare platform
 * Implements rewards and governance functionality
 */
contract MediToken is IMediToken, ERC20, ERC20Burnable, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    
    // Token parameters
    uint256 public constant INITIAL_SUPPLY = 1000000 * 10**18; // 1 million tokens
    uint256 public constant MAX_SUPPLY = 10000000 * 10**18;    // 10 million tokens
    
    constructor() ERC20("MediToken", "MEDI") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    // Additional functions...
}