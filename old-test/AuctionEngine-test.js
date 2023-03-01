const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("AuctionEngine", function () {
  let owner
  let seller
  let buyer
  let auction

  beforeEach(async function () {
    [owner,seller, buyer] = await ethers.getSigners()

    const AuctionEngine = await ethers.getContractFactory("AuctionEngine", owner)
    auction = await AuctionEngine.deploy()
    await auction.deployed()
  })

  it("sets owner", async function () {
    const currentOwner = await auction.owner()
    console.log(currentOwner)
    expect(currentOwner).to.eq(owner.address)
  })

  describe("createAuction", function () {
    it("creates auction successfully", async function () {
      const itemName = "fate item"
      const duration = 60
      const trancation = await auction.connect(seller).createAuction(
        ethers.utils.parseEther("0.0001"),
        3,
        itemName,
        duration
      )

      const currentAuction = await auction.auctions(0)
      const auctionCreatedTime = await getTimeStamp(trancation.blockNumber)

      expect(currentAuction.item).to.eq(itemName)
      expect(currentAuction.endsAt).to.eq(auctionCreatedTime + duration)
    })
  });


  describe("buy", function () {
    it("buy successfully", async function () {
      const itemName = "fate item"
      const duration = 60
      await auction.connect(seller).createAuction(
        ethers.utils.parseEther("0.0001"),
        3,
        itemName,
        duration
      )

      this.timeout(5000)
      delay(1000)

      const trancation = await auction.connect(buyer).buy(
        0,
        {
          value : ethers.utils.parseEther("0.0001")
        }
      )
      const currentAuction = await auction.auctions(0)
      const finalPrice = currentAuction.endPrice

      await expect(() => trancation).to.changeEtherBalance(
        seller, finalPrice - Math.floor((finalPrice * 10) / 100))
      
      await expect(trancation)
        .to.emit(auction, "AuctionEnded")
        .withArgs(0, finalPrice, buyer.address)

      await expect(auction
          .connect(buyer)
          .buy(0, {
            value : ethers.utils.parseEther("0.0001")
          }))
        .to.be.revertedWith("Auction is stopped")
    })
  });


  async function getTimeStamp(blockNumber) {
    return (
      await ethers.provider.getBlock(blockNumber)
    ).timestamp
  }

  function delay(delayTime) {
    return new Promise(resolve => setTimeout(resolve, delayTime))
  }
});