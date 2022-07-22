const { expectRevert, expectEvent, BN } = require('@openzeppelin/test-helpers')
const { expect } = require('chai')
const { BigNumber } = require('ethers')
const { ethers } = require('hardhat')

describe("CollectionCoreV1", () => {

	let alice, bob, charlie, alexandriaAdmin
	let collectionCore
  const pow18 = BigNumber.from('1000000000000000000')

  beforeEach(async () => {
    const accounts = await ethers.getSigners();
    alice = accounts[0];
    bob = accounts[1];
    charlie = accounts[2];
    alexandriaAdmin = accounts[3];
    const CollectionCore = await ethers.getContractFactory('CollectionCoreV1')
    collectionCore = await CollectionCore.deploy()
	})

	it("[sanity]: should initialize", async () => {
    await collectionCore.initialize("Alexandria", "ALEX", {maxSupply: BigNumber.from('1000'), price: pow18, primaryRoyaltyPercentage: BigNumber.from("150"), 
      maxPurchaseNumber: BigNumber.from('5'), reserveNumber: BigNumber.from('0'), contractURI: "", baseURI: "", payoutAddress: alice.address, alexandriaAddress: alexandriaAdmin.address})
	})

	it("[sanity]: cannot initialize twice", async () => {
    await collectionCore.initialize("Alexandria", "ALEX", {maxSupply: BigNumber.from('1000'), price: pow18, primaryRoyaltyPercentage: BigNumber.from("150"), 
      maxPurchaseNumber: BigNumber.from('5'), reserveNumber: BigNumber.from('0'), contractURI: "", baseURI: "", payoutAddress: alice.address, alexandriaAddress: alice.address})
    await expectRevert(collectionCore.initialize("Alexandria", "ALEX", {maxSupply: BigNumber.from('1000'), price: pow18, primaryRoyaltyPercentage: BigNumber.from("150"),
      maxPurchaseNumber: BigNumber.from('5'), reserveNumber: BigNumber.from('0'), contractURI: "", baseURI: "", payoutAddress: alice.address, alexandriaAddress: alice.address}),
      "Initializable: contract is already initialized")
	})

  it("[sanity]: cannot initialize twice", async () => {
    await collectionCore.initialize("Alexandria", "ALEX", {maxSupply: BigNumber.from('1000'), price: pow18, primaryRoyaltyPercentage: BigNumber.from("150"), 
      maxPurchaseNumber: BigNumber.from('5'), reserveNumber: BigNumber.from('0'), contractURI: "", baseURI: "", payoutAddress: alice.address, alexandriaAddress: alice.address})
    await collectionCore.mint(BigNumber.from('1'), alice.address)
    })
   

})