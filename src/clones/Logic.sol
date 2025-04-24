// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Logic {
    // 作用在 Proxy 上
    address public owner;
    uint256 public value;

    // initialize 函数替代构造函数
    // 因为通过代理合约的所有逻辑合约都构造器都没法被重复调用
    function initialize(address _owner, uint256 _value) external {
        require(owner == address(0), "Already initialized");
        owner = _owner;
        value = _value;
    }

    function setValue(uint256 _newValue) external {
        require(msg.sender == owner, "Not owner");
        value = _newValue;
    }
}