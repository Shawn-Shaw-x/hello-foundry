// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Multicall {
    struct Call {
        address target;
        bytes data;
    }

    function multicall(Call[] calldata calls) external returns (bytes[] memory results) {
        results = new bytes[](calls.length);

        for (uint i = 0; i < calls.length; i++) {
            (bool success, bytes memory result) = calls[i].target.call(calls[i].data);
            require(success, "Call failed");
            results[i] = result;
        }
    }
}