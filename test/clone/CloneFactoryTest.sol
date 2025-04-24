// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "../../src/clones/CloneFactory.sol";
import "../../src/clones/Logic.sol";
import "forge-std/Test.sol";


contract CloneFactoryTest is Test {
    Logic logic;
    CloneFactory factory;

    function setUp() public {
        logic = new Logic();
        factory = new CloneFactory(address(logic));
    }

    function testCreateClone() public {
        address owner = address(0x1234);
        uint256 value = 42;
//        创建最小代理
        address clone = factory.createClone(owner, value);
//        将代理转化为 Logic
        Logic logicClone = Logic(clone);
//        验证最小代理的数据是给我们给定的
        assertEq(logicClone.owner(), owner);
        assertEq(logicClone.value(), value);
//        设置当前 msg 地址 为 owner
        vm.prank(owner);
//        通过最小代理进行调用，行为会被转发到 Logic 上，但数据是 Proxy 中的
        logicClone.setValue(99);
        assertEq(logicClone.value(), 99);
    }
}