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
* Automated tests
* Local development with Anvil
* Deployment scripts for different networks

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
│   ├── FundMe.sol
│   └── PriceConverter.sol
│
├── script/
│   ├── DeployFundMe.s.sol
│   └── HelperConfig.s.sol
│
├── test/
│   ├── FundMeTest.t.sol
│   └── mocks/
│       └── MockV3Aggregator.sol
│
├── lib/
│   ├── forge-std/
│   └── chainlink-brownie-contracts/
│
├── foundry.toml
└── README.md
```

## How It Works

Users can call the `fund()` function and send ETH to the contract.

The contract uses Chainlink's price feed to convert the ETH amount into USD:

```solidity
msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD
```

The minimum required amount is:

```text
$5 USD
```

The contract owner can then withdraw the funds using the `withdraw()` function.

## Foundry Commands

### Build

Compile the smart contracts:

```bash
forge build
```

### Test

Run all tests:

```bash
forge test
```

Run a specific test:

```bash
forge test --match-test testWithdrawFromMultipleFunders
```

### Format

Format Solidity files:

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

Start a local Ethereum node:

```bash
anvil
```

### Deploy

Run the FundMe deployment script:

```bash
forge script script/DeployFundMe.s.sol
```

For deployment to a network:

```bash
forge script script/DeployFundMe.s.sol \
    --rpc-url <your_rpc_url> \
    --private-key <your_private_key> \
    --broadcast
```

**Never commit your private key or API keys to GitHub.**

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

Get help with Foundry:

```bash
forge --help
anvil --help
cast --help
```

## Testing

The project contains tests for:

* Minimum USD requirement
* Contract ownership
* Chainlink price feed version
* Funding
* Funder tracking
* Owner-only withdrawals
* Withdrawals with a single funder
* Withdrawals with multiple funders

Run:

```bash
forge test
```

## Chainlink

The project uses the Chainlink `AggregatorV3Interface` to obtain the ETH/USD price.

For local Anvil testing, a mock price feed is used.

For Sepolia, the project uses the Chainlink ETH/USD price feed.

## Documentation

Foundry documentation:

https://book.getfoundry.sh/

## Author

**Kren Muts**
