// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Callee {
    uint public x;
    function setX(uint _x) public {
        x = _x;
    }
    function getX() public view returns (uint) {
        return x;
    }
}