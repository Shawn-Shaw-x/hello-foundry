// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract Proxy {
    address public implementation; // 逻辑合约地址
    address public admin; // admin地址
    // 存储结构必须和 Logic 完全一致
    uint public num;

    // 构造函数，初始化admin和逻辑合约地址
    constructor(address _implementation){
        admin = msg.sender;
        implementation = _implementation;
    }

    // 利用 fallback() 委托调用
    // 不存在的函数都会打到这里，然后 delegate 去调用逻辑合约
    fallback() external payable {
        require(msg.sender != admin); // 禁止管理员调用，防止管理员调用普通函数和升级函数出现选择器冲突，导致升级成黑洞
        (bool success, bytes memory data) = implementation.delegatecall(msg.data);
    }

    // 升级函数，改变逻辑合约地址，只能由admin调用
    function upgrade(address newImplementation) external {
        require(msg.sender == admin);
        implementation = newImplementation;
    }
}
