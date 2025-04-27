// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../../lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";
import "forge-std/Test.sol";
import "forge-std/console2.sol";
import {MessageHashUtils} from "../../lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol";

contract TestSignVerifyOZ is Test {
    using ECDSA for bytes32;

    address signer;
    uint256 privateKey;

    function setUp() public {
        privateKey = 123456789;
        signer = vm.addr(privateKey);
    }

    function testSignAndRecoverOZ() public {
        string memory message = "hello world";

        // 1. 直接把字符串hash
        bytes32 messageHash = keccak256(bytes(message));

        // 2. 用 OZ 帮我们加前缀（标准 Ethereum Signed Message 格式）
        bytes32 ethSignedHash = MessageHashUtils.toEthSignedMessageHash(messageHash);
        console.log("message is:");
        console.logBytes32( ethSignedHash  );

        // 3. 签名，这一步和之前的步骤都发生在链下
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, ethSignedHash);
        console.log("signature is:");
        console.logBytes( abi.encodePacked(r,s,v)  );

        // 4. 恢复 signer
        address recovered = ECDSA.recover(ethSignedHash, v, r, s);

        console.log("recovered is:");
        console.logAddress( recovered  );
        console.log("signer is:");
        console.log(signer);
        assertEq(recovered, signer, "Recovered signer does not match");
    }
}