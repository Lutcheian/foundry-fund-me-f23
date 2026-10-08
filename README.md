# FundMe

A decentralized crowdfunding smart contract built with **Solidity** and **Foundry**.

## Description

FundMe allows users to send ETH to a smart contract while using a **Chainlink price feed** to ensure that the amount sent is worth at least **$5 USD**.

The project includes:

* ETH funding
* Chainlink ETH/USD price feed
* Minimum $5 USD funding requirement
* Owner-only withdrawals
* Multiple funders
* Unit and integration testing
* Local development with Anvil
* Deployment scripts
* Contract interaction scripts

## Technologies

* **Solidity**
* **Foundry**
* **Chainlink**
* **Ethereum**
* **Anvil**

## Project Structure

```text
foundry-fund-me-f23/
│
├── src/
│   ├── Counter.sol
│   ├── FundMe.sol
│   └── PriceConverter.sol
│
├── script/
│   ├── Counter.s.sol
│   ├── DeployFundMe.s.sol
│   ├── HelperConfig.s.sol
│   └── Interactions.s.sol
│
├── test/
│   ├── integration/
│   │   └── InteractionsTest.t.sol
│   │
│   ├── mocks/
│   │   └── MockV3Aggregator.sol
│   │
│   └── unit/
│       └── FundMeTest.t.sol
│
├── lib/
│   ├── forge-std/
│   └── chainlink-brownie-contracts/
│
├── foundry.toml
└── README.md
```

## How It Works

Users can call the `fund()` function and send ETH to the FundMe contract.

The contract uses Chainlink's ETH/USD price feed to convert the ETH amount into USD and checks that the user has sent at least **$5 worth of ETH**.

```solidity
msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD
```

The minimum funding requirement is:

```text
$5 USD
```

The contract owner can withdraw the funds using the `withdraw()` function.

## Main Contracts

### FundMe.sol

The main crowdfunding contract.

It:

* Accepts ETH from users
* Tracks how much each address has funded
* Keeps track of all funders
* Uses Chainlink for ETH/USD conversion
* Restricts withdrawals to the owner

### PriceConverter.sol

Provides functions for converting ETH values into USD values using the Chainlink price feed.

### HelperConfig.s.sol

Provides network-specific configuration.

For example:

* Sepolia uses the Chainlink ETH/USD price feed
* Anvil uses a local mock price feed

### DeployFundMe.s.sol

Deploys the FundMe contract using the appropriate network configuration.

### Interactions.s.sol

Contains scripts for interacting with the deployed FundMe contract.

## Testing

The project uses **unit tests** and **integration tests**.

### Unit Tests

Unit tests are located in:

```text
test/unit/FundMeTest.t.sol
```

These tests cover:

* Minimum USD requirement
* Contract ownership
* Chainlink price feed version
* Funding
* Funder tracking
* Owner-only withdrawals
* Withdrawals with a single funder
* Withdrawals with multiple funders

Run the unit tests with:

```bash
forge test --match-path test/unit/FundMeTest.t.sol
```

### Integration Tests

Integration tests are located in:

```text
test/integration/InteractionsTest.t.sol
```

These tests verify interactions with the deployed contract and related scripts.

Run the integration tests with:

```bash
forge test --match-path test/integration/InteractionsTest.t.sol
```

### Mock Price Feed

The project includes a Chainlink mock:

```text
test/mocks/MockV3Aggregator.sol
```

This mock price feed is used for local testing on Anvil instead of relying on a live Chainlink price feed.

### Run All Tests

Run the complete test suite:

```bash
forge test
```

## Foundry Commands

### Build

Compile the project:

```bash
forge build
```

### Format

Format the Solidity code:

```bash
forge fmt
```

### Gas Snapshots

Create a gas snapshot:

```bash
forge snapshot
```

Create a snapshot for a specific test:

```bash
forge snapshot --match-test testWithdrawFromMultipleFunders
```

### Anvil

Start a local Ethereum development node:

```bash
anvil
```

### Deploy

Run the FundMe deployment script:

```bash
forge script script/DeployFundMe.s.sol
```

Deploy to a network:

```bash
forge script script/DeployFundMe.s.sol \
    --rpc-url <your_rpc_url> \
    --private-key <your_private_key> \
    --broadcast
```

**Never commit private keys, API keys, or `.env` files to GitHub.**

### Interactions

Run the interaction script:

```bash
forge script script/Interactions.s.sol
```

For a live network:

```bash
forge script script/Interactions.s.sol \
    --rpc-url <your_rpc_url> \
    --private-key <your_private_key> \
    --broadcast
```

### Cast

Interact with Ethereum networks using Cast:

```bash
cast <subcommand>
```

For example:

```bash
cast chain-id
```

### Help

```bash
forge --help
anvil --help
cast --help
```

## Chainlink

The project uses Chainlink's `AggregatorV3Interface` to obtain the ETH/USD price.

For local Anvil testing, a mock price feed is used.

For Sepolia testing, the project uses the Chainlink ETH/USD price feed.

## Counter

The project also contains the default Foundry `Counter` example:

```text
src/Counter.sol
script/Counter.s.sol
```

These files were included as part of the original Foundry project setup.

## Documentation

Foundry documentation:

https://book.getfoundry.sh/

## Author

**Kren Muts**
