// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/OrderBook.sol";

contract OrderBookTest is Test {
    OrderBook orderBook;

    address trader1 = address(1);
    address trader2 = address(2);

    function setUp() public {
        orderBook = new OrderBook();

        // Dépôt initial pour les traders
        orderBook.depositTokenA(1000);
        orderBook.depositTokenB(1000);
        vm.prank(trader1);
        orderBook.depositTokenA(100);
        vm.prank(trader2);
        orderBook.depositTokenB(100);
    }

    function testPlaceBuyOrder() public {
        vm.startPrank(trader1);
        orderBook.placeOrder(OrderBook.OrderType.Buy, 10, 5);
        // Récupération de l'ordre en décomposant le tuple
        (
            uint256 id,
            address trader,
            OrderBook.OrderType orderType,
            uint256 amount,
            uint256 price,
            uint256 filled
        ) = orderBook.orders(0);

        assertEq(trader, trader1);
        assertEq(uint(orderType), uint(OrderBook.OrderType.Buy));
        assertEq(amount, 10);
        assertEq(price, 5);
    }

    function testPlaceSellOrder() public {
        vm.startPrank(trader2);
        orderBook.placeOrder(OrderBook.OrderType.Sell, 10, 5);
        // Récupération de l'ordre en décomposant le tuple
        (
            uint256 id,
            address trader,
            OrderBook.OrderType orderType,
            uint256 amount,
            uint256 price,
            uint256 filled
        ) = orderBook.orders(1);

        assertEq(trader, trader2);
        assertEq(uint(orderType), uint(OrderBook.OrderType.Sell)); // Convertir l'enum en uint
        assertEq(amount, 10);
        assertEq(price, 5);
    }

    function testExecuteOrders() public {
        vm.startPrank(trader1);
        orderBook.placeOrder(OrderBook.OrderType.Buy, 10, 5);
        vm.stopPrank();

        vm.startPrank(trader2);
        orderBook.placeOrder(OrderBook.OrderType.Sell, 10, 5);
        vm.stopPrank();

        orderBook.executeOrders();

        assertEq(orderBook.balancesTokenA(trader1), 10);
        assertEq(orderBook.balancesTokenB(trader2), 50);
    }
}
