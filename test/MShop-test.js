const { expect } = require("chai");
const { ethers } = require("hardhat");
const tokenJson = require("../artifacts/contracts/ERC/MCSToken.sol/MCSToken.json");

describe("MShop", function () {
  let owner
  let shop
  let buyer
  let erc20

  beforeEach(async function () {
    [owner, buyer] = await ethers.getSigners()

    const MShop = await ethers.getContractFactory("MShop", owner)
    shop = await MShop.deploy()
    await shop.deployed()

    erc20 = new ethers.Contract(await shop.token(), tokenJson.abi, owner) 
  })

  it("should have an owner and a token", async function () {
    expect(await shop.owner()).to.eq(owner.address)
    expect(await shop.token()).to.be.properAddress
  })

  it("should allow to sell", async function () {
    const tokensToBuy = 3
    const transactionToBuyData = {
      value: tokensToBuy,
      to: shop.address
    }
    const trancationToBuy = await buyer.sendTransaction(transactionToBuyData)
    trancationToBuy.wait()

    const tokensToSell = 2
    const approval =  await erc20.connect(buyer).approve(shop.address, tokensToSell)
    await approval.wait()

    const sellTransaction = await shop.connect(buyer).sell(tokensToSell)
    await sellTransaction.wait()

    expect(await erc20.balanceOf(buyer.address)).to.equal(tokensToBuy - tokensToSell)

    await expect(() => sellTransaction)
      .to.changeEtherBalance(shop, -tokensToSell)

    await expect(() => sellTransaction)
      .to.emit(shop, 'Sold')
      .withArgs(tokensToSell, buyer.address)
  })

  it("should allow to buy", async function () {
    const tokensToBuy = 3
    const transactionData = {
      value: tokensToBuy,
      to: shop.address
    }
    const trancation = await buyer.sendTransaction(transactionData)
    await trancation.wait()
    
    expect(await erc20.balanceOf(buyer.address)).to.equal(tokensToBuy)
    
    await expect(() => trancation)
      .to.changeEtherBalance(shop, tokensToBuy)
    
    await expect(() => trancation)
      .to.emit(shop, 'Bought')
      .withArgs(tokensToBuy, buyer.address)
  })
});