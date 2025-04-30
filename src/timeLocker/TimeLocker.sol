// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "../../lib/openzeppelin-contracts/contracts/utils/Address.sol";

contract TimeLocker {
    /*任务 id => 任务锁定的时间戳*/
    mapping(bytes32 => uint256) private optToTimestamp;
    /*最小延迟时间，每个任务都必须大于这个值*/
    uint256 private minDelay;

    constructor(uint256 _minDelay){
        minDelay = _minDelay;
    }

    /*将执行的某个操作存放到延迟队列中*/
    function scheduleOpt(
        address target,
        uint value,
        bytes calldata data,
        uint256 delay
    ) external {
        /*计算这次操作的 id */
        bytes32 optId = calculateOpt(target, value, data, delay);
        require(optToTimestamp[optId] == 0, "option already in optToTimestamp");
        require(delay >= minDelay, "not enough delay time");
        /*将本次操作 id 放入 map 中，值为锁定的时间戳*/
        optToTimestamp[optId] = block.timestamp + delay;
    }

    /*将延迟队列中的某个操作移除*/
    function cancelOpt(
        address target,
        uint value,
        bytes calldata data,
        uint256 delay
    ) external {
        /*计算这次操作的 id */
        bytes32 optId = calculateOpt(target, value, data, delay);
        require(optToTimestamp[optId] != 0, "option not in optToTimestamp");
        delete optToTimestamp[optId];
    }

    /*执行队列中的某个交易*/
    function executeOpt(
        address target,
        uint value,
        bytes calldata data,
        uint256 delay
    ) external {
        /*计算这次操作的 id */
        bytes32 optId = calculateOpt(target, value, data, delay);
        require(optToTimestamp[optId] != 0, "option not in optToTimestamp");

        /*检查操作是否过了锁定期*/
        uint256 executeTimestamp = optToTimestamp[optId];
        /*当前时间戳大于 map 缓存中的时间戳*/
        require(block.timestamp > executeTimestamp, "option not ready");
        delete optToTimestamp[optId];
        /*转发执行*/
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        Address.verifyCallResult(success, returndata);

    }

    /*计算调用的交易 hash*/
    function calculateOpt(
        address target,
        uint value,
        bytes calldata data,
        uint256 delay
    ) public pure returns (bytes32){
        return keccak256(abi.encode(target, value, data, delay));
    }
}