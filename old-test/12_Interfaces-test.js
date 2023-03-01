const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("12_Interfaces-test", function () {
    let owner
    let demo

    beforeEach(async function () {
        [owner] = await ethers.getSigners()

        const Logger = await ethers.getContractFactory("Logger", owner)
        const logger = await Logger.deploy()
        await logger.deployed()
    
        const Demo = await ethers.getContractFactory("Demo", owner)
        demo = await Demo.deploy(logger.address)
        await demo.deployed()
    })

    it("should pay and get log from logger", async function () {
        const sum = 100
        const transactionData = {
            value : sum,
            to : demo.address,
        }
        const trancation = await owner.sendTransaction(transactionData) 
        await trancation.wait()
        const amount = await demo.payment(owner.address, 0)

        await expect(trancation).to.changeEtherBalance(demo, sum)
        expect(amount).to.equal(sum)
    })
})