// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

// 逻辑合约C
contract LogicC {
    // 状态变量和 Proxy 合约一致，防止插槽冲突
    address public implementation;
    address public admin;
    uint public num; // 字符串，可以通过逻辑合约的函数改变

    // 改变proxy中状态变量，
    function foo() public{
        num = 2;
    }
    // 获取 proxy 中的 num
    function getFoo() public view returns(uint){
        return num;
    }
}