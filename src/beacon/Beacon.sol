// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract Beacon {
    address public implementation;
    address public owner;
    constructor(address impl){
        implementation = impl;
        owner = msg.sender;
    }

//    升级函数
    function updateImplementation(address newImpl) external{
        require(msg.sender == owner, "Not Authorized");
        implementation = newImpl;
    }
// 获取逻辑合约的地址
    function getImplementation() external view returns(address){
        return implementation;
    }
}
