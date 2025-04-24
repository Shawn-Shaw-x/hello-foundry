// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {IERC20Metadata} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol";


contract ShawnERC20 is IERC20, IERC20Metadata {
//    记录某个地址的代币数量
    mapping(address => uint256) public override balanceOf;
//    记录某个地址授权给另一个地址的代币数量
    mapping(address => mapping(address => uint256)) public override allowance;
//    总供应量
    uint256 public override  totalSupply;
    string public override name = "Shawn Token";
    string public override symbol = "SC";
    uint8 public override decimals = 10;
    constructor(string memory name_, string memory symbol_){
        name = name_;
        symbol = symbol_;
    }

//    从 msg.sender 转到 to
    function transfer(address to, uint256 value) external returns (bool){
//        msg.sender 扣减
        balanceOf[msg.sender] -= value;
//        to 加上
        balanceOf[to] += value;
        emit Transfer(msg.sender,to,value);
        return true;
    }

//    授权，只做记录，未发生实际转账
    function approve(address spender, uint256 value) external returns (bool){
//        记录 msg.sender 授权给 spender value 数量的代币
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender,spender, value);
        return true;
    }

//     授权转账
    function transferFrom(address from, address to, uint256 value) external returns (bool){
//        from 从记录中扣减 value 数量的代币
        allowance[from][msg.sender] -= value;
//        实际 from 的余额 扣减
        balanceOf[from] -= value;
//        to 的实际余额增加
        balanceOf[to] += value;
        emit Transfer(from, to, value);
        return true;
    }

//    铸币（当前任何人都能铸币，实际应加上权限控制）
    function mint(uint amount) external {
//        给 sender 加上币
        balanceOf[msg.sender] += amount;
//        供应量增加
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

//    燃烧
    function burn(uint amount) external {
//        sender 扣减
        balanceOf[msg.sender] -= amount;
//        供应量扣减
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}


