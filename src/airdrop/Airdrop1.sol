// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "../../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract Airdrop1 is ERC20, Ownable {
    constructor(string memory _name, string memory _symbol) ERC20(_name,_symbol) Ownable(msg.sender) {
    }

    /*方案一：项目方批量发送空投
    只能项目方（合约拥有者）调用
    */
    function dropForBatch(
        address[] calldata spenders,
        uint256[] calldata values
    ) external onlyOwner() {
        require(spenders.length == values.length, "Lengths of Addresses and Amounts NOT EQUAL");
        /*循环批量给用户 mint */
        for (uint i = 0; i < spenders.length; i++) {
            _mint(spenders[i], values[i]);
        }
    }
}
