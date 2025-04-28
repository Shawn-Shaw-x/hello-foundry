// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../../src/ERC20Permit/MyERC20Permit.sol";
import "forge-std/Test.sol";

contract MyERC20PermitTest is Test {
    MyERC20Permit public token;

    address public owner;
    uint256 public ownerPrivateKey;
    address public spender;

    function setUp() public {
        // 生成测试账户
        ownerPrivateKey = 0xA11CE;
        owner = vm.addr(ownerPrivateKey);
        spender = address(0xBEEF);

        // 部署代币，切换到 owner 的身份
        vm.prank(owner);
        token = new MyERC20Permit("MyToken", "MTK");
    }

    function testPermit() public {
        uint256 value = 100e18;
        uint256 nonce = token.nonces(owner);
        uint256 deadline = block.timestamp + 1 days;

        // 构造 permit 需要的 digest
        bytes32 digest = getPermitDigest(
            "MyToken",
            "1",
            block.chainid,
            address(token),
            owner,
            spender,
            value,
            nonce,
            deadline
        );

        // owner 签名
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, digest);

        // spender 调用 permit
        vm.prank(spender);
        token.permit(owner, spender, value, deadline, v, r, s);

        // 校验 allowance
        uint256 allowance = token.allowance(owner, spender);
        assertEq(allowance, value);

        // spender 再 transferFrom 成功
        vm.prank(spender);
        token.transferFrom(owner, spender, value);

        assertEq(token.balanceOf(spender), value);
    }

    // 帮助函数：构造 EIP712 digest
    function getPermitDigest(
        string memory name,
        string memory version,
        uint256 chainId,
        address verifyingContract,
        address owner_,
        address spender_,
        uint256 value_,
        uint256 nonce_,
        uint256 deadline_
    ) internal pure returns (bytes32) {
        bytes32 DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256(
                    "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                ),
                keccak256(bytes(name)),
                keccak256(bytes(version)),
                chainId,
                verifyingContract
            )
        );

        bytes32 structHash = keccak256(
            abi.encode(
                keccak256(
                    "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
                ),
                owner_,
                spender_,
                value_,
                nonce_,
                deadline_
            )
        );

        return keccak256(
            abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, structHash)
        );
    }
}