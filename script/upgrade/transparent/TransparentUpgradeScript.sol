// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

import {LogicB} from "../../../src/upgrade/transparent/LogicB.sol";
import {LogicC} from "../../../src/upgrade/transparent/LogicC.sol";
import {Proxy} from "../../../src/upgrade/transparent/Proxy.sol";


contract TransparentUpgradeScript is Script {
//    function run() external {
//        // 读取两个私钥
//        uint256 admin = vm.envUint("PRIVATE_KEY_1");
//        uint256 EOA = vm.envUint("PRIVATE_KEY_2");
//
//        vm.startBroadcast(admin);
//        LogicB logicB = new LogicB();
//        LogicC logicC = new LogicC();
//        Proxy proxy = new Proxy(address(logicB));
//        vm.stopBroadcast();
//
//        vm.startBroadcast(EOA);
//        address(proxy).call(abi.encodeWithSignature("foo()"));
//        address(proxy).call(abi.encodeWithSignature("getFoo()"));
//        vm.stopBroadcast();
//        vm.startBroadcast(admin);
//        proxy.upgrade(address(logicC));
//        vm.stopBroadcast();
//        vm.startBroadcast(EOA);
//        address(proxy).call(abi.encodeWithSignature("foo()"));
//        address(proxy).call(abi.encodeWithSignature("getFoo()"));
//        vm.stopBroadcast();
//    }

    function run() external {
        // 读取私钥
        uint256 admin = vm.envUint("PRIVATE_KEY_1");

        vm.startBroadcast(admin);
        LogicB logicB = new LogicB();
        LogicC logicC = new LogicC();
        Proxy proxy = new Proxy(address(logicB));

        address(proxy).call(abi.encodeWithSignature("foo()"));
        address(proxy).call(abi.encodeWithSignature("getFoo()"));

        proxy.upgrade(address(logicC));

        address(proxy).call(abi.encodeWithSignature("foo()"));
        address(proxy).call(abi.encodeWithSignature("getFoo()"));
        vm.stopBroadcast();
    }
}