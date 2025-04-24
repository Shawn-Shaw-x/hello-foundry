// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Diamond {
    address public owner;
    // 选择器 => facet 地址
    mapping(bytes4 => address) public facets;
    constructor() {
        owner = msg.sender;
    }
    function setFacet(bytes4 selector, address facet) external {
        require(msg.sender == owner, "Not owner");
        facets[selector] = facet;
    }
    fallback() external payable {
        address facet = facets[msg.sig];
        require(facet != address(0), "Function does not exist");
        (bool success, bytes memory data) = facet.delegatecall(msg.data);
        _return(data);
    }
    // 用内联汇编黑魔法 封装 return 的逻辑（利用 call 函数返回）
    function _return(bytes memory data) internal pure {
        assembly {
            return(add(data, 0x20), mload(data))
        }
    }
}