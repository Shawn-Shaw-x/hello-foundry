// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "../../src/beacon/Beacon.sol";
import "../../src/beacon/BeaconProxy.sol";
import "../../src/beacon/Logic1.sol";
import "../../src/beacon/Logic2.sol";
import "forge-std/Test.sol";

contract BeaconProxyTest is Test {
    Beacon public beacon;
    BeaconProxy public proxy;
    address public owner;

    Logic1 public logic1;
    Logic2 public logic2;

    function setUp() public {
        owner = address(this);
        // 部署初始逻辑合约
        logic1 = new Logic1();
        // 部署信标
        beacon = new Beacon(address(logic1));
        // 编码初始化调用（可选）
        bytes memory data = abi.encodeWithSignature("get()");
        // 部署代理
        proxy = new BeaconProxy(beacon, data);
    }
//  测试代理调用
    function testCallGetThroughProxy() public {
        // 通过代理合约调用 get()，应该返回 logic1 的内容
        (bool success, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature("get()")
        );

        assertTrue(success);
        string memory result = abi.decode(data, (string));
        assertEq(result, "beacon logic contract 1");
    }
//  升级合约后再尝试代理调用
    function testUpgradeImplementation() public {
        // 部署 logic2
        logic2 = new Logic2();
        // 升级信标指向 logic2
        beacon.updateImplementation(address(logic2));
        // 代理合约调用 get()，应返回 logic2 的内容
        (bool success, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature("get()")
        );
        assertTrue(success);
        string memory result = abi.decode(data, (string));
        assertEq(result, "beacon logic contract 2");
    }
}