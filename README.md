# SimpleSwap

SimpleSwap is a Solidity smart contract that enables token swaps using the Uniswap V3 protocol. It allows users to swap a fixed amount of a spend token for a maximum possible amount of a receive token or swap a fixed amount of a receive token for a minimum possible amount of a spend token.

## Prerequisites

- [Solidity](https://soliditylang.org/) v0.8.18 or compatible version
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/) v4.3.2 or compatible version
- [Uniswap V3 Periphery](https://github.com/Uniswap/uniswap-v3-periphery) v1.0.0 or compatible version

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/mohitchandel/simple-swap.git
   ```

2. Install the dependencies:
   ```bash
   npm i or yarn
   ```
3. Compile the contracts:
   ```bash
   npx hardhat compile
   ```

## Usage

1. Deploy the contract by providing the address of the Uniswap V3 SwapRouter as a constructor argument.

2. Call the `inputSwap` function to swap a fixed amount of a spend token for a maximum possible amount of a receive token.

```solidity
function inputSwap(IERC20 spendToken, IERC20 receiveToken, uint256 amountIn) public returns (uint256)
```

3. Call the outputSwap function to swap a fixed amount of a receive token for a minimum possible amount of a spend token.

```solidity
function outputSwap(IERC20 spendToken, IERC20 receiveToken, uint256 amountInMax, uint256 amountOut) public returns (uint256)
```

## Testing

Run the contract tests:

```bash
npx hardhat test
```
