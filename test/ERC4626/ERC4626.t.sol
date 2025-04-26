// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../src/ERC4626/Shawn4626.sol";
import {Test} from "forge-std/Test.sol";
import {TestERC20} from "./TestERC20.sol";
import "forge-std/console2.sol";

contract TestShawn4626 is Test {
    Shawn4626 vault;
    TestERC20 asset;

    uint256 constant MAX_SUPPLY = 100 * 10 ** 18; // 最大供应量 100 个 vUSDT（考虑精度）
    uint256 constant DEPOSIT_AMOUNT = 1 * 10 ** 18; // 每次存入的资产量（考虑精度）


    function setUp() public {
        // 创建一个 ERC20 资产合约，作为外部资产
        asset = new TestERC20("Test USDT", "USDT");
        // 部署 Shawn4626 Vault 合约
        vault = new Shawn4626(IERC20(address(asset)));

        // 给用户提供一些资产
        asset.mint(address(this),DEPOSIT_AMOUNT * 5); // 给用户 5 倍的存款量
    }

    // 测试最大供应量限制：存入资产时超过最大供应量应该失败
    function testDepositExceedsMaxSupply() public {
        // 存入资产，超过最大供应量
        asset.approve(address(vault), DEPOSIT_AMOUNT);
        vm.expectRevert("Exceeds max supply");
        vault.deposit(DEPOSIT_AMOUNT * 101, address(this));
    }

    // 测试最大供应量限制：mint 超过最大供应量时应该失败
    function testMintExceedsMaxSupply() public {
        asset.approve(address(vault), DEPOSIT_AMOUNT * 101);

        vm.expectRevert("Exceeds max supply");
        // 直接 mint 超过最大供应量
        vault.mint(DEPOSIT_AMOUNT * 101, address(this));

    }

    // 测试正常的存款操作
    function testNormalDeposit() public {
        asset.approve(address(vault), DEPOSIT_AMOUNT);
        vault.deposit(DEPOSIT_AMOUNT, address(this)); // 正常存款
        assertEq(vault.totalSupply(), DEPOSIT_AMOUNT); // 确保总供应量增加
    }

    // 测试正常的 mint 操作
    function testNormalMint() public {
        asset.approve(address(vault), type(uint256).max);
        vault.mint(DEPOSIT_AMOUNT, address(this)); // 正常 mint
        assertEq(vault.totalSupply(), DEPOSIT_AMOUNT); // 确保总供应量增加
    }

    // 测试正常的存款和 mint 组合
    function testDepositAndMint() public {
        asset.approve(address(vault), type(uint256).max);
//        默认 1：1 兑换
        console2.log("share of DEPOSIT_AMOUNT is " , vault.previewDeposit(DEPOSIT_AMOUNT));
        vault.deposit(DEPOSIT_AMOUNT, address(this)); // 正常存款

        vault.mint(DEPOSIT_AMOUNT, address(this)); // 再正常 mint

        assertEq(vault.totalSupply(), DEPOSIT_AMOUNT * 2); // 确保总供应量正确
    }
}