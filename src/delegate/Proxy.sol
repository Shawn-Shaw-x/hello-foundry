// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Proxy {
    // 存储结构必须和 Logic 完全一致
    uint public num;

    function delegateSetNum(address logic, uint _num) public {
        (bool success, ) = logic.delegatecall(
            abi.encodeWithSignature("setNum(uint256)", _num)
        );
        require(success, "delegatecall failed");
    }
}