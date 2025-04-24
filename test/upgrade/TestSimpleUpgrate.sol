// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import {LogicB} from "../../src/upgrade/simple/LogicB.sol";
import {Proxy} from "../../src/upgrade/simple/Proxy.sol";
import {LogicC} from "../../src/upgrade/simple/LogicC.sol";


contract SimpleUpgrateTest is Test {
    LogicB logicB;
    LogicC logicC;
    Proxy proxy;

    function setUp() public {
         logicB = new LogicB();
        logicC = new LogicC();
         proxy = new Proxy(address(logicB));
    }

    function testSimpleUpgrade() public {
        address(proxy).call(abi.encodeWithSignature("foo()"));
//        data 为 0x，因为 fallback() 无法返回data，但可以采用内联汇编魔法返回，这里暂且不谈
        (bool success, bytes memory data) = address(proxy).call(abi.encodeWithSignature("getFoo()"));
        assertEq(success,true,"success should eq true");

        proxy.upgrade(address(logicC));
        address(proxy).call(abi.encodeWithSignature("foo()"));
    (bool success1, bytes memory data1) = address(proxy).call(abi.encodeWithSignature("getFoo()"));
        assertEq(success1,true,"success should eq true");
    }
}