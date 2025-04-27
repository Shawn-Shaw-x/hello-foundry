// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {ECDSA} from "../../lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

contract ERC712Verify {
    // Domain 结构
    bytes32 private constant DOMAIN_TYPE_HASH =
    keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
    // Types 结构
    bytes32 private constant PERMIT_TYPE_HASH =
    keccak256("Permit(address owner,address spender,uint256 value)");

    // Domain 结构+值
    bytes32 public DOMAIN_SEPARATOR;

    constructor(string memory name, string memory version) {
        DOMAIN_SEPARATOR = _buildDomainSeparator(name, version);
    }

    // 实际调用业务
    // 根据传入数据，恢复出来消息 Hash ，验签
    function permitAndDoSomething(
        address owner,
        address spender,
        uint256 value,
        bytes memory signature
    ) external {
        // 恢复出来消息
        bytes32 structHash = keccak256(
            abi.encode(
                PERMIT_TYPE_HASH,
                owner,
                spender,
                value
            )
        );
        bytes32 digest = keccak256(abi.encodePacked(
            "\x19\x01",
            DOMAIN_SEPARATOR, structHash));


        address recovered = ECDSA.recover(digest, signature);
        require(recovered == owner, "verify signature fail");

        //todo do some business logic

    }

    // 固定好 Domain 结构
    function _buildDomainSeparator(string memory name, string memory version) private view returns (bytes32) {
        return keccak256(abi.encode(DOMAIN_TYPE_HASH, keccak256(bytes(name)), keccak256(bytes(version)), block.chainid, address(this)));
    }
}