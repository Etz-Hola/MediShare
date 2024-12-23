// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title IMediToken
 * @dev Interface for the MediToken contract
 */
interface IMediToken {
    function mint(address to, uint256 amount) external;
    function burn(uint256 amount) external;
    function burnFrom(address account, uint256 amount) external;
}
