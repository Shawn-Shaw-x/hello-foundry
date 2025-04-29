// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "../../src/airdrop/Airdrop2.sol";
import "forge-std/Test.sol";

contract Airdrop2Test is Test {
    Airdrop2 public token;

    address user1 = address(0x1);
    address user2 = address(0x2);
    address user3 = address(0x3); // 非空投地址

    bytes32 public root;
    bytes32[] public proof;
    bytes32 public leaf1;
    bytes32 public leaf2;

    function setUp() public {
        // 构建 Merkle Tree (2个地址)
        address[] memory recipients = new address[](2);
        uint256[] memory amounts = new uint256[](2);
        recipients[0] = user1;
        recipients[1] = user2;
        amounts[0] = 100 ether;
        amounts[1] = 200 ether;

        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = keccak256(abi.encodePacked(recipients[0], amounts[0]));
        leaves[1] = keccak256(abi.encodePacked(recipients[1], amounts[1]));

        // 构建 Merkle Tree 手动计算 root (简单两层)
        // 若已排序：hash(left, right)
        leaf1 = leaves[0];
        leaf2 = leaves[1];
        if (leaf1 < leaf2) {
            root = keccak256(abi.encodePacked(leaf1, leaf2));
        } else {
            root = keccak256(abi.encodePacked(leaf2, leaf1));
        }
        console.log("==== root =====");
        console.logBytes32(root);
        token = new Airdrop2("AirdropToken", "ATK", root);
    }

    /*有效 proof*/
    function testAirdropWithValidProof() public {
        vm.prank(user1);
        /*这里仅用 1 个兄弟节点替代，
        默克尔树较深的肯定不止一个，
        leaf2 为 leaf1 的兄弟节点
        */
        proof = new bytes32[](1);
        proof[0] = leaf2;
        token.dropForMerkleProof(user1, 100 ether, proof);
        assertEq(token.balanceOf(user1), 100 ether);
        assertTrue(token.mintedAddress(user1));
    }

    /*无效地址*/
    function testAirdropWithWrongProof() public {
        vm.prank(user3);
        proof = new bytes32[](1);
        proof[0] = leaf2;
        vm.expectRevert("Invalid merkle proof!");
        token.dropForMerkleProof(user3, 300 ether, proof); // 错误地址 + 错误 proof

    }

}