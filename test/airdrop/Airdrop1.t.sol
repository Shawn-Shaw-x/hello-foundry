// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "../../src/airdrop/Airdrop1.sol";
import "forge-std/Test.sol";

contract Airdrop1Test is Test {
    Airdrop1 public airdrop;
    address public owner;
    address public user1 = address(0x1);
    address public user2 = address(0x2);

    function setUp() public {
        owner = address(this);
        airdrop = new Airdrop1("TestToken", "TTK");
    }

    function testBatchDrop() public {
        address[] memory receivers = new address[](2);
        uint256[] memory amounts = new uint256[](2);

        receivers[0] = user1;
        receivers[1] = user2;
        amounts[0] = 100 ether;
        amounts[1] = 200 ether;

        airdrop.dropForBatch(receivers, amounts);

        assertEq(airdrop.balanceOf(user1), 100 ether);
        assertEq(airdrop.balanceOf(user2), 200 ether);
    }

}