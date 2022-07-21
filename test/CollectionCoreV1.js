const { expectRevert, expectEvent, BN } = require('@openzeppelin/test-helpers')
const { expect } = require('chai')
const { BigNumber } = require('ethers')
const { ethers } = require('hardhat')

describe("CollectionCoreV1", () => {

	let alice, bob, charlie
	let collectionCore
  const pow18 = BigNumber.from('1000000000000000000')

  beforeEach(async () => {
    const accounts = await ethers.getSigners();
    alice = accounts[0];
    bob = accounts[1];
    charlie = accounts[2];
    const CollectionCore = await ethers.getContractFactory('CollectionCoreV1')
    collectionCore = await CollectionCore.deploy()
	})

	it("[sanity]: should initialize", async () => {
    await collectionCore.initialize("Alexandria", "ALEX", {maxSupply: BigNumber.from('1000'), pow18, BigNumber.from("150"), maxPurchaseNumber: BigNumber.from('5'), })
	})

  
	it("[sanity]: cannot initialize twice", async () => {
    await 
	})


})