// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "../../src/diamond/Diamond.sol";
import "../../src/diamond/FacetA.sol";
import "../../src/diamond/FacetB.sol";
import "forge-std/Test.sol";


contract DiamondTest is Test {
    Diamond diamond;
    FacetA facetA;
    FacetB facetB;
    function setUp() public {
        diamond = new Diamond();
        facetA = new FacetA();
        facetB = new FacetB();

        // 注册 selector 到 Facet
        diamond.setFacet(FacetA.getFacetANum.selector, address(facetA));
        diamond.setFacet(FacetB.getFacetBMessage.selector, address(facetB));
    }
    function testFacetA() public {
        (bool success2, bytes memory data) = address(diamond).call(abi.encodeWithSelector(FacetA.getFacetANum.selector));
        assertTrue(success2);
        assertEq(abi.decode(data, (uint)), 1);
    }
    function testFacetB() public {
        (bool success2, bytes memory data) = address(diamond).call(abi.encodeWithSelector(FacetB.getFacetBMessage.selector));
        assertTrue(success2);
        assertEq(abi.decode(data, (string)), "hello facetB");
    }
}