// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "../../src/timeLocker/TimeLocker.sol";
import "forge-std/Test.sol";

contract Target {
    uint256 public value;

    function setValue(uint256 _value) external {
        value = _value;
    }
}

contract TimeLockerTest is Test {
    TimeLocker locker;
    Target target;

    address user = address(0xBEEF);
    uint256 minDelay = 1 days;

    function setUp() public {
        locker = new TimeLocker(minDelay);
        target = new Target();
        vm.deal(user, 1 ether);
    }
    /*测试操作锁定、执行*/
    function testScheduleAndExecute() public {
        // 构造 calldata
        bytes memory data = abi.encodeWithSignature("setValue(uint256)", 42);
        uint256 valueToSend = 0;
        uint256 delay = 2 days;


        // 调用 scheduleOpt
        locker.scheduleOpt(address(target), valueToSend, data, delay);

        // 确保还未到执行时间不能执行
        vm.expectRevert("option not ready");
        locker.executeOpt(address(target), valueToSend, data, delay);

        // 跳过时间
        vm.warp(block.timestamp + delay + 1);

        // 执行操作
        locker.executeOpt(address(target), valueToSend, data, delay);

        // 验证目标合约状态已更新
        assertEq(target.value(), 42);
    }

    /*测试打断锁定，取消执行*/
    function testCancel() public {
        bytes memory data = abi.encodeWithSignature("setValue(uint256)", 100);
        uint256 valueToSend = 0;
        uint256 delay = 1 days;

        // 调用 scheduleOpt
        locker.scheduleOpt(address(target), valueToSend, data, delay);

        // 取消
        locker.cancelOpt(address(target), valueToSend, data, delay);

        // 再次执行应 revert
        vm.expectRevert("option not in optToTimestamp");
        locker.executeOpt(address(target), valueToSend, data, delay);
    }
}