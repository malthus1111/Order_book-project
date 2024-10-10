// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/OrderBook.sol";

contract DeployOrderBook is Script {
    function run() external {
        vm.startBroadcast();
        OrderBook orderBook = new OrderBook();
        vm.stopBroadcast();
    }
}
