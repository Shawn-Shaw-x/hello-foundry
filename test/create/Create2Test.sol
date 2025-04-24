// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "../../src/create/create2.sol";
import "forge-std/Test.sol";

contract FactoryTest is Test {
    Factory public factory;

    function setUp() public {
        factory = new Factory();
    }

    function testDeployWithCreate2() public {
        uint256 inputAge = 42;
        address deployed = factory.deploy(inputAge);

        // 强转成 Foo，读取 age 是否正确
        uint256 age = Foo(deployed).age();
        assertEq(age, inputAge);
    }

    function testForecastAddress() public {
        uint256 inputAge = 42;
        bytes32 salt = factory.SALT();
        bytes memory bytecode = abi.encodePacked(
            type(Foo).creationCode,
            abi.encode(inputAge)
        );

        // 计算预测地址
        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0xff),
                address(factory),
                salt,
                keccak256(bytecode)
            )
        );
        address predicted = address(uint160(uint256(hash)));

        // 部署并获取真实地址
        address deployed = factory.deploy(inputAge);

        assertEq(deployed, predicted, "CREATE2 address mismatch");

        // 验证 age 值
        uint256 age = Foo(deployed).age();
        assertEq(age, inputAge);
    }
}