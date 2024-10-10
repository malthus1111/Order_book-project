# Order-Book Solidity Project

## Description

Ce projet est un **order-book** simple développé en Solidity. Il permet la création, l'annulation et l'exécution (matching) d'ordres d'achat et de vente entre deux tokens : **TokenA** et **TokenB**. Ce smart contract est conçu pour gérer les ordres de manière basique en stockant les informations nécessaires (quantité, prix, type d'ordre) et en permettant l'interaction avec les ordres de manière sécurisée.

## Fonctionnalités

1. **Créer un ordre d'achat ou de vente** avec une quantité et un prix spécifié.
2. **Annuler un ordre** existant.
3. **Matcher des ordres** pour effectuer une transaction entre un ordre d'achat et un ordre de vente.
4. Gestion des soldes utilisateurs pour les tokens **TokenA** et **TokenB**.
5. Test complet avec Foundry pour vérifier le bon fonctionnement des ordres.

## Structure du Projet

- **src/**: Contient le smart contract `OrderBook.sol` qui gère les ordres et les interactions avec les utilisateurs.
- **test/**: Contient les tests unitaires (`OrderBookTest.sol`) pour valider les différentes fonctionnalités du contrat.
- **script/**: Contient le script de déploiement (`deploy.s.sol`) pour automatiser la mise en place du smart contract sur un réseau de test.

## Prérequis

- **Foundry**: Framework pour tester et déployer des smart contracts Solidity.
- **Solidity**: Version 0.8.0 ou supérieure.
- **Git**: Pour gérer le code source.

## Installation

1. **Cloner le projet:**
   ```bash
   git clone https://github.com/malthus1111/order-book-project.git
   cd order-book-project
   ```

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
