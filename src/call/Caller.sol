// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



contract Caller {
    function callSetX(address calleeAddress, uint _x) public {
        (bool success, ) = calleeAddress.call(
            abi.encodeWithSignature("setX(uint256)", _x)
        );
        require(success, "setX call failed");
    }

    function callGetX(address calleeAddress) public view returns (uint) {
        (bool success, bytes memory data) = calleeAddress.staticcall(
            abi.encodeWithSignature("getX()")
        );
        require(success, "getX call failed");
        return abi.decode(data, (uint));
    }
}