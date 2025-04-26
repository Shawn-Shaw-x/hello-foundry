// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "../../lib/openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";

contract Shawn1155 is ERC1155 {
    uint256 constant MAX_ID = 10;
    constructor() ERC1155("ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/ "){
//        mint 出来给自己
        mintBatch();
    }

    // 批量 mint 出来
    function mintBatch() internal {
        uint256[] memory ids = new uint256[](MAX_ID);
        uint256[] memory amounts = new uint256[](MAX_ID);
        for(uint256 i=0;i<MAX_ID;i++){
            ids[i] = i;
            amounts[i] = 1000;
        }
        _mintBatch(msg.sender,ids,amounts,"");
    }

}
