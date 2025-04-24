// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "../../src/create/create.sol";
import "forge-std/Test.sol";

contract FactoryTest is Test {
    Factory public factory;

    function setUp() public {
        factory = new Factory();
    }

    function testCreatesNewFoo() public {
        uint256 inputAge = 18;

        address fooAddr = factory.deploy(inputAge);

        // 检查合约是否被成功部署
        assertTrue(fooAddr.code.length > 0, "Contract code should exist");

        // 调用 Foo 的 age() 验证构造函数赋值
        uint256 age = Foo(fooAddr).age();
        assertEq(age, inputAge);
    }
}