// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {ERC20} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {MerkleProof} from "../../lib/openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";

contract Airdrop2 is ERC20 {
    /*空投默克尔树根 hash*/
    bytes32 immutable public rootHash;
    /*记录已空投的地址*/
    mapping(address => bool) public mintedAddress;

    constructor(string memory _name, string memory _symbol, bytes32 _rootHash) ERC20(_name,_symbol){
        rootHash = _rootHash;
    }

    /*
    方案二：默克尔证明
    用 MerkleProof 库判断 （spender + value） 和 proof 构建的 recoverRoothash 是否和 rootHash 一致
    */
    function dropForMerkleProof(
        address spender,
        uint256 value,
        bytes32[] calldata proof
    ) external {
        /*已经空投过*/
        require(!mintedAddress[spender],"Aleardy minted!");
        /*用 地址 + 数量 构建叶子节点 hash*/
        bytes32 leafHash = keccak256(abi.encodePacked(spender,value));
        bool inAirdrop = MerkleProof.verify(proof,rootHash,leafHash);
        /*校验默克尔证明是否正确*/
        require(inAirdrop,"Invalid merkle proof!");
        mintedAddress[spender] = true;
        _mint(spender, value);
    }
}
