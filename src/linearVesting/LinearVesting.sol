// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "../../lib/forge-std/src/interfaces/IERC20.sol";
import {Ownable} from "../../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract LinearVesting is Ownable {
    /*记录已领取数量*/
    mapping(address => uint256) public erc20Released;
    uint256 public immutable start;
    uint256 public immutable duration;

    /*构造函数，初始化合约参数*/
    constructor(uint256 _start, uint256 _duration, address beneficiary) Ownable(beneficiary){
        start = _start;
        duration = _duration;
    }
    /*受益人提币*/
    function release(address token) external {
        /*计算可提币数量 = 已释放数量 - 已提取数量*/
        uint256 releasable = vestedAmount(token, uint256(block.timestamp)) - erc20Released[token];
        /*更新已提取数量*/
        erc20Released[token] += releasable;
//      /*转出*/
        IERC20(token).transfer(owner(), releasable);
    }

    /*计算已释放数量*/
    function vestedAmount(address token, uint256 timestamp) public view returns (uint256){
        /*合约中有多少币(总共释放多少)*/
        uint256 totalAllocation = IERC20(token).balanceOf(address(this)) + erc20Released[token];
        /*根据线性释放公式，计算已释放的数量*/
        if (timestamp < start) {
            /*未到释放时间*/
            return 0;
        } else if (timestamp >= start + duration) {
            /*超时全部释放*/
            return totalAllocation;
        } else {
            /* （总量 x 已过时长）/ 总时长*/
            return (totalAllocation * (timestamp - start)) / duration;
        }
    }
}