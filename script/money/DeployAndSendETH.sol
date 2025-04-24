pragma solidity ^0.8.20;

import "forge-std/Script.sol";

contract PayableReceiver {
    event Received(address sender, uint256 amount, string functionType);

    receive() external payable {
    }

    fallback() external payable {
    }

}

contract DeployAndSendETH is Script {
    function run() external {
        vm.startBroadcast();

        PayableReceiver receiver = new PayableReceiver();

        // 1. 使用 call（无 data） -> 触发 receive
        (bool successCall, ) = address(receiver).call{value: 1 ether}("");
        require(successCall, "call failed");

        // 2. 使用 transfer -> 触发 receive
        payable(address(receiver)).transfer(1 ether);

        // 3. 使用 send -> 触发 receive
        bool successSend = payable(address(receiver)).send(1 ether);
        require(successSend, "send failed");

        // 4. 使用 call + data -> 触发 fallback
        (bool successFallback, ) = address(receiver).call{value: 1 ether}("0x1234");
        require(successFallback, "call with data (fallback) failed");

        vm.stopBroadcast();
    }
}