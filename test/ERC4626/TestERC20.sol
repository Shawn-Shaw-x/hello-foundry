// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {ERC20} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract TestERC20 is ERC20 {
    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {
    }

    //    铸币（当前任何人都能铸币，实际应加上权限控制）
    function mint(address user,uint amount) external {
        _mint(user, amount);
    }
}
