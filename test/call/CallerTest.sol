// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../../src/call/Callee.sol";
import "../../src/call/Caller.sol";
import "forge-std/Test.sol";


contract CallerTest is Test {
    Callee public callee;
    Caller public caller;

    function setUp() public {
        callee = new Callee();
        caller = new Caller();
    }

    function testCallSetAndGetX() public {
        // 设置 x 为 123
        caller.callSetX(address(callee), 123);

        // 获取 x 的值
        uint value = caller.callGetX(address(callee));

        assertEq(value, 123, "x should be 123");
    }
}