import { ethers } from "hardhat";

async function main() {
  const swapRouterAddress = "SWAP_ROUTER_ADDRESS";

  const SwapRouter = await ethers.getContractFactory("ISwapRouter");
  const swapRouter = SwapRouter.attach(swapRouterAddress);

  const SimpleSwap = await ethers.getContractFactory("SimpleSwap");
  const simpleSwap = await SimpleSwap.deploy(swapRouter.address);

  await simpleSwap.deployed();

  console.log("SimpleSwap deployed to:", simpleSwap.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
