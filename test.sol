// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.19;
pragma abicoder v2;

import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';
import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';
//import '@uniswap/v3-periphery/contracts/libraries/PoolAddress.sol';
import '@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol';
//import '@uniswap/v3-core/contracts/interfaces/INonfungiblePositionManager.sol';

contract SimpleSwap {
    ISwapRouter public immutable swapRouter=ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
    address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public constant WETH9 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    uint24 public constant feeTier = 3000;
    address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

   // constructor(ISwapRouter _swapRouter) {
     //   swapRouter = _swapRouter;
   //}

    function swapWETHForDAI(uint256 amountIn) external returns (uint256 amountOut) {

        // Transfer the specified amount of WETH9 to this contract.
        TransferHelper.safeTransferFrom(WETH9, msg.sender, address(this), amountIn);
        // Approve the router to spend WETH9.
        TransferHelper.safeApprove(WETH9, address(swapRouter), amountIn);
        // Note: To use this example, you should explicitly set slippage limits, omitting for simplicity
        uint256 minOut = /* Calculate min output */ 0;
        uint160 priceLimit = /* Calculate price limit */ 0;
        // Create the params that will be used to execute the swap
        ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: WETH9,
                tokenOut: DAI,
                fee: feeTier,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: minOut,
                sqrtPriceLimitX96: priceLimit
            });
        // The call to `exactInputSingle` executes the swap.
        amountOut = swapRouter.exactInputSingle(params);
    }
    function swapdaiforeth(uint256 amountIn)external returns(uint256 amountout){

        TransferHelper.safeTransferFrom(DAI,msg.sender,address(this),amountIn);
        TransferHelper.safeApprove(DAI,address(swapRouter),amountIn);
        uint256 minOut = /* Calculate min output */ 0;
        uint160 priceLimit = /* Calculate price limit */ 0;

        ISwapRouter.ExactInputSingleParams memory params=ISwapRouter.ExactInputSingleParams({
            tokenIn:DAI,
            tokenOut:WETH9,
            fee:feeTier,
            recipient:msg.sender,
            deadline:block.timestamp +120,
            amountIn:amountIn,
            amountOutMinimum:minOut,
            sqrtPriceLimitX96: priceLimit

        });
        amountout=swapRouter.exactInputSingle(params);

    }
    //function getpool(address a,address b, uint256 fee)internal  returns(IUniswapV3Pool){
       // return IUniswapV3Pool(PoolAddress.computeAddress(factory,PoolAddress.getpoolkey(a,b,fee));

    //}
    function swapethtodaitousdc(uint256 amountIn)external returns(uint256 amountOut){
                TransferHelper.safeTransferFrom(WETH9,msg.sender,address(this),amountIn);
                TransferHelper.safeApprove(WETH9,address(swapRouter),amountIn);

            ISwapRouter.ExactInputParams memory params=ISwapRouter.ExactInputParams({
                path:abi.encodePacked(WETH9,feeTier,DAI,feeTier,USDC),
                recipient:msg.sender,
                deadline:block.timestamp,
                amountIn:amountIn,
                amountOutMinimum:0
            });
            amountOut=swapRouter.exactInput(params);
    }
        

}
