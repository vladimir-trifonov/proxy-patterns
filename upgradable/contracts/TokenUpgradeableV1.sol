// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./IToken.sol";

/*
 * @title Token - A custom ERC20 token contract with minting capabilities
 * @dev This contract extends the OpenZeppelin ERC20 and Ownable contracts, and implements the IToken interface
 * The owner of the contract has the ability to mint new tokens
 */
contract TokenUpgradeableV1 is
    Initializable,
    ERC20Upgradeable,
    OwnableUpgradeable,
    IToken
{
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(
        string memory name,
        string memory symbol
    ) public initializer {
        __ERC20_init(name, symbol);
        __Ownable_init();
    }

    /**
     * @dev Checks if a contract implements the IToken or IERC20 interface.
     * @param interfaceId The interface ID being checked.
     * @return A boolean indicating if the contract implements the IToken and the IERC20 interface.
     */
    function supportsInterface(bytes4 interfaceId) public pure returns (bool) {
        return
            interfaceId == type(IToken).interfaceId ||
            interfaceId == type(IERC20).interfaceId;
    }

    /*
     * @dev Mints a specified amount of tokens and transfers them to the specified recipient address
     * This function can only be called by the contract owner
     * @param to The address to receive the minted tokens
     * @param amount The amount of tokens to be minted
     */
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}
