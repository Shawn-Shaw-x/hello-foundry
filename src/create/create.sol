// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract Foo {
    uint256 public age;
    constructor(uint256 _age) {
        age = _age;
    }
}

contract Factory {
    function deploy(uint256 _age) external returns (address) {
        Foo foo = new Foo(_age); // 使用 `CREATE` 指令创建新合约
        return address(foo);
    }
}