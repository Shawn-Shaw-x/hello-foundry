// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "../../src/multiSignature/MultiSignature.sol";
import "forge-std/Test.sol";

contract MultiSignatureTest is Test {
    uint8 constant MAX_SIGNEE = 3;

    MultiSignature multiSig;
    address[MAX_SIGNEE] owners;
    uint256[MAX_SIGNEE] privatekeys;

    // 签名的交易数据
    address to = address(0x123);
    uint256 value = 1 ether;
    bytes data = abi.encodeWithSignature("setValue(uint256)", 123);

    function setUp() public {
        for(uint i=0;i<MAX_SIGNEE;i++){
            // 用时间戳生成随机私钥
            uint256 privateKey = uint256(keccak256(abi.encodePacked(block.timestamp, i)));
            // 使用 Foundry 的 vm.addr() 来根据私钥生成地址
            address addr = vm.addr(privateKey);
            owners[i] = addr;
            privatekeys[i] = privateKey;
        }
        multiSig = new MultiSignature(owners);
        // 为合约地址分配一定的 ETH，方便测试多签合约转出 (例如：100 ETH)
        vm.deal(address(multiSig), 100 ether);
    }
    /*执行交易*/
    function testExecuteTransaction() public {
        /*构建 32 字节消息 hash*/
        bytes32 messageHash = buildMessageHash(to, value, data);

        // 模拟链下签名，并聚合成一个签名
        bytes memory signatures = generateSignatures(messageHash);

        // 执行交易
        multiSig.executeTransaction(to, value, data, signatures);
    }

    /*生成并聚合签名*/
    function generateSignatures(bytes32 messageHash) public returns (bytes memory) {
        uint8 v;
        bytes32 r;
        bytes32 s;
        // 模拟签名
        (v,r, s) = vm.sign(privatekeys[1], messageHash);
        bytes memory sig1 = abi.encodePacked(r, s, v);
        // 模拟签名
        (v,r, s) = vm.sign(privatekeys[2], messageHash);
        bytes memory sig2 = abi.encodePacked(r, s, v);

        return abi.encodePacked(sig1, sig2);
    }

    /*使用消息原始数据恢复出来消息 hash */
    function buildMessageHash(
        address to,
        uint256 value,
        bytes memory data
    ) internal view returns (bytes32){
        bytes32 dataHash = keccak256(abi.encode(to, value, keccak256(data)));
        bytes32 messageHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash));
        return messageHash;
    }

}