// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract MyERC20Permit is ERC20Permit {
    constructor(string memory name,string memory symbol) ERC20(name,symbol) ERC20Permit(name) {
        // 初始给部署者 mint 一些代币，比如 1000 个
        _mint(msg.sender, 1000 * 1e18);
    }
}