// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {Beacon} from "./Beacon.sol";

contract BeaconProxy {
    Beacon public beacon;

//    初始化 proxy，并尝试调用一次 logic
    constructor(Beacon _beacon, bytes memory data){
        beacon = _beacon;
        if(data.length >0){
            (bool success,) = _implementation().delegatecall(data);
            require(success, "Init failed");
        }
    }
//  delegatecall转发
    fallback() external payable{
        _delegate(_implementation());
    }
//  delegatecall转发
    receive() external payable{
        _delegate(_implementation());
    }
// 通过调用 Beacon 合约获取真正的实现地址
    function _implementation() internal view returns(address){
        address impl = beacon.getImplementation();
        require(impl != address(0), "beacon call failed");
        return impl;
    }

//    delegatecall 并用魔法返回 return 值
    function _delegate(address impl) internal{
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())

            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }
}
