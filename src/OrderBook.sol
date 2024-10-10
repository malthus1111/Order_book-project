// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OrderBook {
    // DJe défini ici mes 2 ordres d'achat et de vente
    enum OrderType {
        Buy,
        Sell
    }

    struct Order {
        uint256 id;
        address trader;
        OrderType orderType;
        uint256 amount; // Quantité de tokens échangés
        uint256 price; // Prix de l'échange
        uint256 filled; // Quantité de tokens déjà échangés
    }

    // Je fai un suivi des ordres
    uint256 public nextOrderId;
    mapping(uint256 => Order) public orders;
    uint256[] public buyOrderIds;
    uint256[] public sellOrderIds;

    // Je garde une trace des soldes des 2 tokens A et B qui me permettent de faire les échanges
    mapping(address => uint256) public balancesTokenA;
    mapping(address => uint256) public balancesTokenB;

    // Événements
    event OrderPlaced(
        uint256 id,
        address trader,
        OrderType orderType,
        uint256 amount,
        uint256 price
    );
    event OrderCancelled(uint256 id);
    event OrderExecuted(
        uint256 buyOrderId,
        uint256 sellOrderId,
        uint256 amount
    );

    // Fonction pour Placer un ordre
    function placeOrder(
        OrderType orderType,
        uint256 amount,
        uint256 price
    ) external {
        require(amount > 0, "Amount must be greater than zero");
        require(price > 0, "Price must be greater than zero");

        if (orderType == OrderType.Sell) {
            require(
                balancesTokenA[msg.sender] >= amount,
                "Insufficient TokenA balance"
            );
            balancesTokenA[msg.sender] -= amount;
        }

        Order memory newOrder = Order(
            nextOrderId,
            msg.sender,
            orderType,
            amount,
            price,
            0
        );
        orders[nextOrderId] = newOrder;

        if (orderType == OrderType.Buy) {
            buyOrderIds.push(nextOrderId);
        } else {
            sellOrderIds.push(nextOrderId);
        }

        emit OrderPlaced(nextOrderId, msg.sender, orderType, amount, price);
        nextOrderId++;
    }

    // Fonction pour annuler un ordre
    function cancelOrder(uint256 orderId) external {
        Order storage order = orders[orderId];
        require(
            order.trader == msg.sender,
            "Only the trader can cancel the order"
        );
        require(order.filled == 0, "Order already partially or fully filled");

        if (order.orderType == OrderType.Sell) {
            balancesTokenA[order.trader] += order.amount;
        }

        delete orders[orderId];
        emit OrderCancelled(orderId);
    }

    // Exécuter les ordres correspondant aux conditions de prix
    function executeOrders() external {
        for (uint256 i = 0; i < buyOrderIds.length; i++) {
            Order storage buyOrder = orders[buyOrderIds[i]];

            for (uint256 j = 0; j < sellOrderIds.length; j++) {
                Order storage sellOrder = orders[sellOrderIds[j]];

                if (
                    buyOrder.price >= sellOrder.price &&
                    buyOrder.filled < buyOrder.amount &&
                    sellOrder.filled < sellOrder.amount
                ) {
                    uint256 fillAmount = min(
                        buyOrder.amount - buyOrder.filled,
                        sellOrder.amount - sellOrder.filled
                    );

                    buyOrder.filled += fillAmount;
                    sellOrder.filled += fillAmount;

                    // j'échange les tokens
                    balancesTokenA[buyOrder.trader] += fillAmount;
                    balancesTokenB[sellOrder.trader] +=
                        fillAmount *
                        sellOrder.price;
                    balancesTokenB[buyOrder.trader] -=
                        fillAmount *
                        sellOrder.price;

                    emit OrderExecuted(buyOrder.id, sellOrder.id, fillAmount);

                    // Si l'ordre est entièrement éffectué, je le retire de la liste
                    if (buyOrder.filled == buyOrder.amount) {
                        removeOrderFromList(buyOrderIds, i);
                    }
                    if (sellOrder.filled == sellOrder.amount) {
                        removeOrderFromList(sellOrderIds, j);
                    }
                }
            }
        }
    }

    // Utilitaire pour retirer un ordre de la liste
    function removeOrderFromList(
        uint256[] storage orderList,
        uint256 index
    ) internal {
        if (index >= orderList.length) return;

        orderList[index] = orderList[orderList.length - 1];
        orderList.pop();
    }

    // Utilitaire pour obtenir le minimum de deux nombres
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    // Déposer des tokens dans le contrat pour effectuer des transactions
    function depositTokenA(uint256 amount) external {
        balancesTokenA[msg.sender] += amount;
    }

    function depositTokenB(uint256 amount) external {
        balancesTokenB[msg.sender] += amount;
    }
}
