// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "../../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {ECDSA} from "../../lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";
import {MessageHashUtils} from "../../lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol";

contract Airdrop3 is ERC20, Ownable{
    mapping(address => bool) public mintedAddress;
    constructor(string memory _name, string memory _symbol) ERC20(_name,_symbol) Ownable(msg.sender){
    }

    /*方案三：使用数字签名验证空投人是否有权限
    未针对签名可重放攻击，
    需要避免签名可重放攻击需加上 nonce、chainId、deadline 来构建消息进行签名
    */
    function dropForSignature(
    address spender,
    uint256 value,
    bytes calldata signature
    ) external {
        require(!mintedAddress[spender], "Already minted!");
        /*恢复 messageHash*/
        bytes32 dataHash = keccak256(abi.encodePacked(spender,value));
        bytes32 messageHash = MessageHashUtils.toEthSignedMessageHash(dataHash);

        /*从 messageHash 和 signature中恢复地址*/
        address recovered = ECDSA.recover(messageHash, signature);
        require(owner() == recovered,"verify signature fail");
        mintedAddress[spender] = true;
        _mint(spender,value);
    }


}
