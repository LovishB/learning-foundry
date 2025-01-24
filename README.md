# Solidity Storage and Funding Contract

This project demonstrates fundamental Solidity concepts including different storage types, contract funding mechanisms, and price feed integration using Chainlink. Built with Foundry.

## Contracts

### UnderstandStorages.sol
Demonstrates different types of storage in Solidity:
- Blockchain storage (persistent state variables)
- Contract bytecode (constants and immutables)
- Memory (temporary function variables)
- EVM stack (local variables)

### FundMe.sol
A crowdfunding contract that:
- Accepts ETH contributions (minimum 5 USD equivalent)
- Converts ETH to USD using Chainlink price feeds
- Allows only owner to withdraw funds
- Includes fallback functions for direct transfers
- Uses gas-optimized storage patterns

### PriceConverter.sol
Library for ETH/USD conversion using Chainlink price feeds:
- Gets latest ETH/USD price
- Converts ETH amounts to USD
- Handles decimal precision

## Deployment

The project includes deployment scripts for multiple networks:
- Sepolia testnet
- Ethereum mainnet
- Local Anvil network (with mock price feeds)

### Configuration
`HelperConfig.sol` manages network-specific configurations:
- Automatically detects network from chain ID
- Provides appropriate price feed addresses
- Deploys mock aggregator for local testing

## Setup

1. Clone the repository
2. Install Foundry:
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```
3. Install dependencies:
```bash
forge install
```

## Testing

Run tests with:
```bash
forge test
```

## Storage Layout

View contract storage layout:
```bash
forge inspect FundMe storageLayout
```

## Key Features

- Gas-optimized storage patterns
- Chainlink price feed integration
- Multi-network deployment support
- Comprehensive storage type examples
- Secure withdrawal mechanisms
- Mock contracts for local testing

## License

MIT