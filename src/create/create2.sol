// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract Foo {
    uint256 public age;
    constructor(uint256 _age) {
        age = _age;
    }
}

contract Factory {
    bytes32 constant public SALT = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
    function deploy(uint256 _age) external returns (address) {
//      Foo foo = new Foo(_age); // 使用 `CREATE` 指令创建新合约

        Foo foo = new Foo{salt: SALT}(_age); // CREATE2 指令

        return address(foo);
    }
}