// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../../src/ERC712/ERC712Verify.sol";
import "forge-std/Test.sol";

contract ERC712VarifyTest is Test {
    ERC712Verify public verifyContract;
    uint256 private privateKey;
    address private signer;
    bytes32 public DOMAIN_SEPARATOR;

    bytes32 private constant PERMIT_TYPE_HASH =
    keccak256("Permit(address owner,address spender,uint256 value)");

    // 初始化合约，测试账户和私钥
    function setUp() public {
        verifyContract = new ERC712Verify("MyApp", "1");
        privateKey = 0xA11CE; // 自定义私钥（测试用）
        DOMAIN_SEPARATOR = verifyContract.DOMAIN_SEPARATOR(); // 发起调用，获取固定的 Domain 结构 + 值
        signer = vm.addr(privateKey); // 用私钥获取 signer 地址

    }

    // 测试签名验证函数
    function testPermitAndDoSomething() public {
        address spender = address(0xBEEF);
        uint256 value = 100;

        // 构造结构体哈希
        bytes32 structHash = keccak256(
            abi.encode(
                PERMIT_TYPE_HASH,
                signer,
                spender,
                value
            )
        );

        // 构造完整的 digest
        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01", // EIP-712 指定的固定前缀
                DOMAIN_SEPARATOR,
                structHash
            )
        );

        // 使用 signer 对 digest 进行签名
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, digest);
        bytes memory signature = abi.encodePacked(r, s, v);

        // 调用合约，验证签名并执行业务逻辑
        vm.expectCall(address(verifyContract), abi.encodeWithSelector(verifyContract.permitAndDoSomething.selector, signer, spender, value, signature));
        verifyContract.permitAndDoSomething(signer, spender, value, signature);

    }
}