// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "../../src/call/DemoContract.sol";
import "../../src/call/Multicall.sol";
import "forge-std/Test.sol";


contract MulticallTest is Test {
    Multicall public multicall;
    DemoContract public demo;

    function setUp() public {
        multicall = new Multicall();
        demo = new DemoContract();
    }

    function testMulticall() public {
        // 准备 calldata
        bytes memory call1 = abi.encodeWithSelector(demo.getOne.selector);
        bytes memory call2 = abi.encodeWithSelector(demo.getTwo.selector);

        Multicall.Call[] memory calls  = new Multicall.Call[](2);
        calls[0] = Multicall.Call(address(demo), call1);
        calls[1] = Multicall.Call(address(demo), call2);

        bytes[] memory results = multicall.multicall(calls);

        uint256 res1 = abi.decode(results[0], (uint256));
        uint256 res2 = abi.decode(results[1], (uint256));

        assertEq(res1, 1);
        assertEq(res2, 2);
    }
}