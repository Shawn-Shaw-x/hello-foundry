// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {ERC4626} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC4626.sol";
import {IERC20} from "../../lib/openzeppelin-contracts/contracts/interfaces/IERC20.sol";
import {ERC20} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";


contract Shawn4626 is ERC4626 {
    uint256 constant MAX_SUPPLY = 100 * 10 ** 18; // 最小单位，供应 100 个 vUSDT
    // 为避免精度换算问题，统一用 ERC 内置的精度 18
//    uint8 constant VUSDT_DECIMAL = 10;

    // 初始化出来内嵌的 ERC20 代币和外部资产的地址
    constructor(IERC20 asset_) ERC20("Voult USDT","vUSDT") ERC4626(asset_) {
    }


    /// 限制最大 mint 出的 vUSDT 数量为 100（10^18 最小单位）
    function deposit(uint256 assets, address receiver) public override returns (uint256) {
        uint256 shares = previewDeposit(assets);
        require(totalSupply() + shares <= MAX_SUPPLY, "Exceeds max supply");

        _deposit(msg.sender, receiver, assets, shares);
        return shares;
    }

    /// 如果允许直接 mint，可以在这里限制 max supply
    function mint(uint256 shares, address receiver) public override  returns (uint256 assets)  {
        require(totalSupply() + shares <= MAX_SUPPLY, "Exceeds max supply");
        super.mint(shares, receiver);
        return shares;
    }
}
