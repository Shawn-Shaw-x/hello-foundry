// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "../../src/ERC20/ShawnERC20.sol";
import "forge-std/Script.sol";

contract DeployShawnERC20 is Script {
    function run() external {
        vm.startBroadcast();

        // 部署 ERC20 合约
        ShawnERC20 token = new ShawnERC20("Shawn Token", "SC");

        // mint 给部署者 100 SC
        token.mint(100 ether);

        // 定义其他地址
        address to = address(0xBEEF);         // 接收地址
        address spender = address(0xCAFE);    // 被授权地址

        // 发送 10 SC 给 to
        token.transfer(to, 10 ether);

        // burn 10 SC（从 msg.sender 地址销毁）
        token.burn(10 ether);

        vm.stopBroadcast();
    }
}