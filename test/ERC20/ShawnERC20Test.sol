// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "../../src/ERC20/ShawnERC20.sol";
import "forge-std/Test.sol";

contract ShawnERC20Test is Test {
    ShawnERC20 token;
    address alice = address(1);
    address bob = address(2);

    function setUp() public {
        token = new ShawnERC20("Shawn Token", "SC");
    }

    function testMint() public {
        vm.prank(alice);
        token.mint(10);
        assertEq(token.totalSupply(), 10);
        assertEq(token.balanceOf(alice), 10);
    }

    function testTransfer() public {
        vm.prank(alice);
        token.mint(10);

        vm.prank(alice);
        token.transfer(bob, 3);

        assertEq(token.balanceOf(alice), 7);
        assertEq(token.balanceOf(bob), 3);
    }

    function testApproveAndTransferFrom() public {
        vm.prank(alice);
        token.mint(10);

        vm.prank(alice);
        token.approve(bob, 3);
        assertEq(token.allowance(alice, bob), 3);

        vm.prank(bob);
        token.transferFrom(alice, bob, 2);

        assertEq(token.balanceOf(bob), 2);
        assertEq(token.balanceOf(alice), 8);
        assertEq(token.allowance(alice, bob), 1);
    }

    function testBurn() public {
        vm.prank(alice);
        token.mint(10);

        vm.prank(alice);
        token.burn(8);

        assertEq(token.balanceOf(alice), 2);
        assertEq(token.totalSupply(), 2);
    }
}