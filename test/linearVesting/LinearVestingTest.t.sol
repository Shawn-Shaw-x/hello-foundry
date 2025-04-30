// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {ERC20 as OZERC20} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../../src/linearVesting/LinearVesting.sol";
import "forge-std/Test.sol";

contract MockToken is OZERC20 {
    constructor() OZERC20("MockToken", "MTK") {}
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract LinearVestingTest is Test {
    LinearVesting vesting;
    MockToken token;
    address beneficiary;

    uint256 start = uint256(keccak256(abi.encodePacked(block.timestamp)));
    uint256 duration = 30 minutes;
    uint256 constant TOTAL_AMOUNT = 1_000 ether;

    function setUp() public {
        /*受益人*/
        beneficiary = address(0xBEEF);
        /*构建合约*/
        vesting = new LinearVesting(start, duration, beneficiary);
        token = new MockToken();
        /*铸币*/
        token.mint(address(this), TOTAL_AMOUNT);
        /*转入合约中，待释放*/
        token.transfer(address(vesting), TOTAL_AMOUNT);
    }

    /*释放之前、之间、之后*/
    function test_Releases() public {
        /*之前*/
        console.log("==== start =====");
        console.logUint(start);
        console.log("===== duration ====");
        console.logUint(duration);
        vm.warp(start - duration);
        vm.prank(beneficiary);
        vesting.release(address(token));

        uint256 expectedBefore = 0;
        /*释放 0 */
        assertEq(token.balanceOf(beneficiary), expectedBefore);

        /*之间*/
        vm.warp(start + duration / 2);
        vm.prank(beneficiary);
        vesting.release(address(token));

        uint256 expected = TOTAL_AMOUNT / 2;
        /*一半时间提取，应该释放一半代币*/
        assertEq(token.balanceOf(beneficiary), expected);

    }
}
