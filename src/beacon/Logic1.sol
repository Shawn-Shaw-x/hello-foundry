// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract Logic1 {
    string constant BEACONLOGIC = "beacon logic contract 1" ;
    function get() external pure returns(string memory) {
        return BEACONLOGIC;
    }
}
