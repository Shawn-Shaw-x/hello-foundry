// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

import {LogicB} from "../../../src/upgrade/uups/LogicB.sol";
import {LogicC} from "../../../src/upgrade/uups/LogicC.sol";
import {Proxy} from "../../../src/upgrade/uups/Proxy.sol";


contract UUPSUpgrade is Script {
    function run() external {
        // 私钥
        uint256 admin = vm.envUint("PRIVATE_KEY_1");

        vm.startBroadcast(admin);
        LogicB logicB = new LogicB();
        LogicC logicC = new LogicC();
        Proxy proxy = new Proxy(address(logicB));

        address(proxy).call(abi.encodeWithSignature("foo()"));
        address(proxy).call(abi.encodeWithSignature("getFoo()"));

        bytes memory callBytes = abi.encodeWithSignature("upgrade(address)",address(logicC));
        address(proxy).call(callBytes);

        address(proxy).call(abi.encodeWithSignature("foo()"));
        address(proxy).call(abi.encodeWithSignature("getFoo()"));
        vm.stopBroadcast();
    }
}