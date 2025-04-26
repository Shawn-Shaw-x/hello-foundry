// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;
import "../../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
contract ShawnNFT is ERC721 {
    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_){
//        固定发行量为 1000，全部 mint 给合约部署者
        for(uint tokenId = 0; tokenId < 1000; tokenId++){
            _mint(msg.sender, tokenId);
        }
    }

//  重写 ERC721 里面的逻辑，指向 BAYC 的 metadata 地址
    function _baseURI() internal pure override returns (string memory){
        return "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/";
    }
}
