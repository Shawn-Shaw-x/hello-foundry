// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "../../lib/solidity-bytes-utils/contracts/BytesLib.sol";
import {ECDSA} from "../../lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";
    using BytesLib for bytes;

contract MultiSignature {
    uint8 public constant MAX_SIGNEE = 3;
    // 多签的门限值
    uint8 public constant threshold = 2;

    // 多签人数组
    address[MAX_SIGNEE] public owners;

    event ExecutionSuccess(bytes32 txHash);    // 交易成功事件
    event ExecutionFailure(bytes32 txHash);    // 交易失败事件

    // 初始化签名地址
    constructor(address[MAX_SIGNEE] memory _owners){
        for (uint256 i = 0; i < MAX_SIGNEE; i++) {
            address owner = _owners[i];
            require(owner != address(0) && owner != address(this), "signee address wrong!");
            owners[i] = owner;
        }
    }

    // 验签后执行交易（利用call进行转发）
    function executeTransaction(address to, uint256 value, bytes memory data, bytes memory signatures) external {
        /*恢复消息 hash*/
        bytes32 messageHash = recoverMessageHash(to, value, data);
        /*检查签名*/
        checkSignatures(messageHash, signatures);
        /*执行多签钱包调用、转出资金*/
        (bool success,) = to.call{value: value}(data);
        if (success) {
            emit ExecutionSuccess(messageHash);
        } else {
            emit ExecutionFailure(messageHash);
            revert("Transaction failed");
        }
    }

    /*检查签名是否正确*/
    function checkSignatures(bytes32 messageHash, bytes memory signatures) internal view {
        /*检查签名长度是否正确*/
        require(signatures.length >= threshold * 65, "signature length is wrong");
        uint pos = 0;
        for (uint i = 0; i < threshold; i++) {
            address recovered = ECDSA.recover(messageHash, signatures.slice(pos, 65));
            pos = pos + 65;
            require(checkInOwner(recovered), "verify fail! signatures are wrong!");
        }
    }

    /*检查是否在多签人数组中*/
    function checkInOwner(address recovered) view internal returns (bool){
        for (uint i = 0; i < MAX_SIGNEE; i++) {
            if (owners[i] == recovered) {
                return true;
            }
        }
        return false;
    }

    /*使用消息原始数据恢复出来消息 hash */
    function recoverMessageHash(
        address to,
        uint256 value,
        bytes memory data
    ) internal view returns (bytes32){

        bytes32 dataHash = keccak256(abi.encode(to, value, keccak256(data)));
        bytes32 messageHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash));
        return messageHash;
    }
}
