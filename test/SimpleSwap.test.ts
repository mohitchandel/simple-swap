import { HardhatEthersSigner } from "@nomicfoundation/hardhat-ethers/signers";
import { expect } from "chai";
import { BaseContract, ContractTransactionResponse, Contract } from "ethers";
import { ethers } from "hardhat";

describe("SimpleSwap", function () {
  let SimpleSwap;
  let simpleSwap: BaseContract & {
    deploymentTransaction(): ContractTransactionResponse;
  } & Omit<Contract, keyof BaseContract>;
  let swapRouterMock;
  let spendTokenMock: any;
  let receiveTokenMock: any;
  let accounts: HardhatEthersSigner[] | { address: any }[];

  before(async function () {
    accounts = await ethers.getSigners();

    // Deploying mocks
    const SwapRouterMock = await ethers.getContractFactory("SwapRouterMock");
    swapRouterMock = await SwapRouterMock.deploy();
    await swapRouterMock.deployed();

    const TokenMock = await ethers.getContractFactory("TokenMock");
    spendTokenMock = await TokenMock.deploy();
    await spendTokenMock.deployed();

    receiveTokenMock = await TokenMock.deploy();
    await receiveTokenMock.deployed();

    // Deploying SimpleSwap contract
    SimpleSwap = await ethers.getContractFactory("SimpleSwap");
    simpleSwap = await SimpleSwap.deploy(swapRouterMock.address);
    await simpleSwap.deployed();
  });

  it("should swap tokens using inputSwap", async function () {
    const amountIn = ethers.utils.parseEther("1");
    const expectedAmountOut = ethers.utils.parseEther("2");

    await spendTokenMock.approve(simpleSwap.address, amountIn);
    await simpleSwap.inputSwap(spendTokenMock, receiveTokenMock, amountIn);

    const balance = await receiveTokenMock.balanceOf(accounts[0].address);
    expect(balance).to.equal(expectedAmountOut);
  });

  it("should swap tokens using outputSwap", async function () {
    const amountInMax = ethers.utils.parseEther("2");
    const amountOut = ethers.utils.parseEther("1");

    await spendTokenMock.approve(simpleSwap.address, amountInMax);
    await simpleSwap.outputSwap(
      spendTokenMock,
      receiveTokenMock,
      amountInMax,
      amountOut
    );

    const balance = await receiveTokenMock.balanceOf(accounts[0].address);
    expect(balance).to.equal(amountOut);
  });
});
