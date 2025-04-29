// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../../src/airdrop/Airdrop3.sol";

contract Airdrop3Test is Test {
    Airdrop3 public token;
    address public owner;
    uint256 public ownerPrivateKey;
    address public user1;
    uint256 public user1PrivateKey;

    function setUp() public {
        ownerPrivateKey = 0xAAAAA;
        owner = vm.addr(ownerPrivateKey); // owner 拥有合约
        vm.prank(owner);
        token = new Airdrop3("AirdropToken", "ADT");

        // 创建 user1 地址
        user1PrivateKey = 0xA11CE; // 只是个示例私钥
        user1 = vm.addr(user1PrivateKey);
    }

    /*测试成功签名领取空投*/
    function testSuccessfulAirdropBySignature() public {
        uint256 amount = 100 ether;

        // 构造签名消息
        bytes32 dataHash = keccak256(abi.encodePacked(user1, amount));
        bytes32 messageHash = MessageHashUtils.toEthSignedMessageHash(dataHash);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, messageHash);
        bytes memory signature = abi.encodePacked(r, s, v);

        // 伪造成 user1 调用合约领取
        vm.prank(user1);
        token.dropForSignature(user1, amount, signature);

        // 校验领取是否成功
        assertEq(token.balanceOf(user1), amount);
        assertTrue(token.mintedAddress(user1));
    }

    /*测试验签失败*/
    function testAirdropBySignatureFail() public {
        uint256 amount = 100 ether;

        // 构造签名消息
        bytes32 dataHash = keccak256(abi.encodePacked(user1, amount));
        bytes32 messageHash = MessageHashUtils.toEthSignedMessageHash(dataHash);
        /*给个错误的私钥去签名*/
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(user1PrivateKey, messageHash);
        bytes memory signature = abi.encodePacked(r, s, v);

        // 伪造成 user1 调用合约领取
        vm.prank(user1);
        vm.expectRevert("verify signature fail");
        token.dropForSignature(user1, amount, signature);

    }
}