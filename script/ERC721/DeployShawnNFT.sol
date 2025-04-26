// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "../../src/ERC721/ShawnNFT.sol";
import "forge-std/Script.sol";

contract DeployShawnNFT is Script {
    function run() external {
        // 获取当前部署者地址
        address deployer = vm.addr(vm.envUint("PRIVATE_KEY"));

        vm.startBroadcast();

        // 1. 部署合约
        ShawnNFT nft = new ShawnNFT("Shawn NFT", "SNFT");

        // 2. 查看部署者拥有多少 NFT
        uint256 balance = nft.balanceOf(deployer);
        console.log("Deployer NFT Balance:", balance);

        // 3. 将第一个 tokenId 转移给另一个地址（用于演示）
        address recipient = address(0xBEEF); // 可以换成你想测试的地址
        nft.safeTransferFrom(deployer, recipient, 0);
        console.log("Transferred tokenId 0 to recipient.");

        vm.stopBroadcast();
    }
}