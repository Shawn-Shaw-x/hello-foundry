// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FacetB {
    function getFacetBMessage() public view returns (string memory) {
        return "hello facetB";
    }
}