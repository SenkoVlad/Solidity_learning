const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("12_Extensions-test", function () {
    let owner
    let demo
    let LibDemo;

    beforeEach(async function () {
        [owner] = await ethers.getSigners()

        const LibDemo = await ethers.getContractFactory("LibDemo", owner)
        libDemo = await LibDemo.deploy()
        await libDemo.deployed()
    })

    it("should compare two strings as eqaul", async function () {
        var result = await libDemo.runnerStr("string1", "string1")
        expect(result).to.equal(true)
    })

    it("should compare two strings as not eqaul", async function () {
        var result = await libDemo.runnerStr("string1", "24542")
        expect(result).to.equal(false)
    })

    it("should find an element in array", async function () {
        var result = await libDemo.runnerUintArray([1, 2, 3], 2)
        expect(result).to.equal(true)
    })

    it("should compare two strings as not eqaul", async function () {
        var result = await libDemo.runnerUintArray([1, 2, 3], 4)
        expect(result).to.equal(false)
    })
})