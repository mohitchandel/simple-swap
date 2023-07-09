// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.18;

import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SimpleSwap {
    ISwapRouter public swapRouter;

    uint24 internal poolFee = 3000;

    constructor(ISwapRouter _swapRouter) {
        swapRouter = _swapRouter;
    }

    // swaps a fixed amount of spendToken for a maximum possible amount of recieveToken
    function inputSwap(
        IERC20 spendToken,
        IERC20 recieveToken,
        uint256 amountIn
    ) public returns (uint256) {
        uint256 token_allowance = spendToken.allowance(
            msg.sender,
            address(swapRouter)
        );

        // Checking for token allowance
        if (token_allowance < amountIn) {
            TransferHelper.safeApprove(
                address(spendToken),
                address(swapRouter),
                amountIn
            );
        }

        TransferHelper.safeTransferFrom(
            address(spendToken),
            msg.sender,
            address(this),
            amountIn
        );

        // Generating params
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: address(spendToken),
                tokenOut: address(recieveToken),
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

        return swapRouter.exactInputSingle(params);
    }

    function outputSwap(
        IERC20 spendToken,
        IERC20 recieveToken,
        uint256 amountInMax,
        uint256 amountOut
    ) public returns (uint256) {
        uint256 token_allowance = spendToken.allowance(
            msg.sender,
            address(swapRouter)
        );

        // Checking for token allowance
        if (token_allowance < amountInMax) {
            TransferHelper.safeApprove(
                address(spendToken),
                address(swapRouter),
                amountInMax
            );
        }

        TransferHelper.safeTransferFrom(
            address(spendToken),
            msg.sender,
            address(this),
            amountInMax
        );

        ISwapRouter.ExactOutputSingleParams memory params = ISwapRouter
            .ExactOutputSingleParams({
                tokenIn: address(spendToken),
                tokenOut: address(recieveToken),
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountOut: amountOut,
                amountInMaximum: amountInMax,
                sqrtPriceLimitX96: 0
            });

        uint256 amountIn = swapRouter.exactOutputSingle(params);

        if (amountIn < amountInMax) {
            TransferHelper.safeApprove(
                address(recieveToken),
                address(swapRouter),
                0
            );
            TransferHelper.safeTransfer(
                address(recieveToken),
                msg.sender,
                amountInMax - amountIn
            );
        }

        return amountIn;
    }
}
