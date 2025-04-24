// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract Logic2 {
    string constant BEACONLOGIC = "beacon logic contract 2" ;
    function get() external pure returns(string memory) {
        return BEACONLOGIC;
    }
}
