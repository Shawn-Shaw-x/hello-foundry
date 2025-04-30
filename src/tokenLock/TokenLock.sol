// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "../../lib/forge-std/src/interfaces/IERC20.sol";
import {Ownable} from "../../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract TokenLock is Ownable {
    /*被锁仓的代币*/
    address public token;
     /*锁仓期*/
    uint256 public immutable lockTime;
    /*开始时间*/
    uint256 public immutable startTime;

    /*构造函数*/
    constructor(address _token,address beneficiary,uint256 _startTime, uint256 _lockTime) Ownable(beneficiary){
        require(_lockTime>0,"LockTime must be greater than zero");
        token = _token;
        startTime = _startTime;
        lockTime = _lockTime;
    }

    /*请求释放，检查锁仓期，然后释放*/
    function release() public {
        /*检查时间戳是否已过锁仓期*/
        require(block.timestamp >= startTime + lockTime,"you should wait for release");
        uint256 amount = IERC20(token).balanceOf(address(this));
        require(amount > 0, "not enough tokens for this release");
        IERC20(token).transfer(owner(),amount);
    }
}