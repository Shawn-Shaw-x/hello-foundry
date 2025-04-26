// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../src/ERC1155/Shawn1155.sol";
import "forge-std/Script.sol";

contract DeployAndTransfer is Script {
    function run() external {
        vm.startBroadcast();

        // 1. 部署合约
        Shawn1155 token = new Shawn1155();
        console2.log("Deployed Shawn1155 at:", address(token));

        // 2. 生成一个随机地址（模拟 EOA 接收者）
        address randomEOA = address(uint160(uint256(keccak256(abi.encodePacked(block.timestamp, blockhash(block.number - 1))))));
        console2.log("Random receiver:", randomEOA);

        // 3. 发送 tokenId 1，数量 100 给 randomEOA
        token.safeTransferFrom(msg.sender, randomEOA, 1, 100, "");

        vm.stopBroadcast();
    }
}