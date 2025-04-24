// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../../lib/openzeppelin-contracts/contracts/proxy/Clones.sol";
import "./Logic.sol";

contract CloneFactory {
    address public implementation;
    address[] public allClones;

    event CloneCreated(address indexed clone);

    constructor(address _implementation) {
        implementation = _implementation;
    }

    function createClone(address _owner, uint256 _value) external returns (address) {
//        OZ 库创建 clone（proxy）
        address clone = Clones.clone(implementation);
//        将 clone（代理） 地址类型转换为 Logic 类型，方便我们调用函数
        Logic(clone).initialize(_owner, _value);
//        维护 clones 列表
        allClones.push(clone);
        emit CloneCreated(clone);
        return clone;
    }

    function getClones() external view returns (address[] memory) {
        return allClones;
    }
}