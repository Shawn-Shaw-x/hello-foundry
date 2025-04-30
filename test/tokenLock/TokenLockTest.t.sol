// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {ERC20 as OZERC20} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../../src/tokenLock/TokenLock.sol";
import "forge-std/Test.sol";

contract MockERC20 is OZERC20 {
    constructor() OZERC20("Mock", "MOCK") {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
    function burn(address account, uint256 value) external{
        _burn(account, value);
    }
}

contract TokenLockTest is Test {
    MockERC20 public token;
    TokenLock public lock;

    address public beneficiary = address(0xBEEF);
    uint256 public start;
    uint256 public lockDuration = 7 days;
    uint256 public amount = 1_000 ether;

    /*初始化*/
    function setUp() public {
        token = new MockERC20();
        start = block.timestamp + 1 days;

        // 创建锁仓合约
        lock = new TokenLock(address(token), beneficiary, start, lockDuration);

        // 铸币并转入锁仓合约
        token.mint(address(this), amount);
        token.transfer(address(lock), amount);
    }

    /*锁仓期内，资金为 0*/
    function test_RevertIfNoTokens() public {
        // 清空代币
        vm.warp(start + lockDuration);
        console.logUint(token.balanceOf(address(lock)));
        /*先烧掉 lock 里面的所有资金*/
        token.burn(address(lock), amount);


        vm.prank(beneficiary);
        vm.expectRevert("not enough tokens for this release");
        lock.release();
    }

    /*锁仓期内，不能释放*/
    function test_CannotReleaseBeforeUnlockTime() public {
        vm.warp(start + lockDuration / 2);
        vm.prank(beneficiary);
        vm.expectRevert("you should wait for release");
        lock.release();
    }
    /*锁仓期后，可以释放*/
    function test_CanReleaseAfterUnlockTime() public {
        vm.warp(start + lockDuration);
        vm.prank(beneficiary);
        lock.release();

        assertEq(token.balanceOf(beneficiary), amount);
    }
}