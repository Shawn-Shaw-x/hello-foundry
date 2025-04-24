// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../../src/delegate/Logic.sol";
import "../../src/delegate/Proxy.sol";
import "forge-std/Test.sol";


contract DelegateCallTest is Test {
    Logic public logic;
    Proxy public proxy;

    function setUp() public {
        logic = new Logic();
        proxy = new Proxy();
    }

    function testDelegateCallSetNum() public {
        proxy.delegateSetNum(address(logic), 999);

        // proxy 的 num 应该更新了（不是 logic）
        assertEq(proxy.num(), 999, "Proxy's num should be updated to 999");

        // logic 的 num 仍然是 0
        assertEq(logic.num(), 0, "Logic's num should remain 0");
    }
}