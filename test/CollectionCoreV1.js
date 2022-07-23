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

  it("can mint", async () => {
    await collectionCore.initialize("Alexandria", "ALEX", {maxSupply: BigNumber.from('1000'), price: pow18, primaryRoyaltyPercentage: BigNumber.from("150"), 
      maxPurchaseNumber: BigNumber.from('5'), reserveNumber: BigNumber.from('0'), contractURI: "", baseURI: "https://website/", payoutAddress: alice.address, alexandriaAddress: alice.address})
    await collectionCore.connect(alice).mint(BigNumber.from('1'), alice.address, {value: pow18})
    expect(await collectionCore.balanceOf(alice.address)).to.equal(BigNumber.from('1'))
    expect(await collectionCore.totalSupply()).to.equal(BigNumber.from('1'))
    expect(await collectionCore.tokenURI(1)).to.equal("https://website/1")
  })

  it("can mint multiple", async () => {
    await collectionCore.initialize("Alexandria", "ALEX", {maxSupply: BigNumber.from('1000'), price: pow18, primaryRoyaltyPercentage: BigNumber.from("150"), 
      maxPurchaseNumber: BigNumber.from('5'), reserveNumber: BigNumber.from('0'), contractURI: "", baseURI: "https://website/", payoutAddress: alice.address, alexandriaAddress: alice.address})
    await collectionCore.connect(alice).mint(BigNumber.from('4'), alice.address, {value: pow18.mul(BigNumber.from('4'))})
    expect(await collectionCore.balanceOf(alice.address)).to.equal(BigNumber.from('4'))
    expect(await collectionCore.totalSupply()).to.equal(BigNumber.from('4'))
    expect(await collectionCore.tokenURI(1)).to.equal("https://website/1")
    expect(await collectionCore.tokenURI(2)).to.equal("https://website/2")
  })

  it("cannot mint over maxMintNumber", async () => {
    await collectionCore.initialize("Alexandria", "ALEX", {maxSupply: BigNumber.from('1000'), price: pow18, primaryRoyaltyPercentage: BigNumber.from("150"), 
      maxPurchaseNumber: BigNumber.from('5'), reserveNumber: BigNumber.from('0'), contractURI: "", baseURI: "https://website/", payoutAddress: alice.address, alexandriaAddress: alice.address})
    await expectRevert(collectionCore.connect(alice).mint(BigNumber.from('6'), alice.address, {value: pow18.mul(BigNumber.from('6'))}), "max purchase number exceeded")
  })

  it("can mint unlimited if maxMintNumber = 0", async () => {
    await collectionCore.initialize("Alexandria", "ALEX", {maxSupply: BigNumber.from('1000'), price: pow18, primaryRoyaltyPercentage: BigNumber.from("150"), 
      maxPurchaseNumber: BigNumber.from('0'), reserveNumber: BigNumber.from('0'), contractURI: "", baseURI: "https://website/", payoutAddress: alice.address, alexandriaAddress: alice.address})
    await collectionCore.connect(alice).mint(BigNumber.from('13'), alice.address, {value: pow18.mul(BigNumber.from('13'))})
    expect(await collectionCore.balanceOf(alice.address)).to.equal(BigNumber.from('13'))
    expect(await collectionCore.totalSupply()).to.equal(BigNumber.from('13'))
    expect(await collectionCore.tokenURI(1)).to.equal("https://website/1")
    expect(await collectionCore.tokenURI(13)).to.equal("https://website/13")
  })

  it("can reserveMint", async () => {
    await collectionCore.initialize("Alexandria", "ALEX", {maxSupply: BigNumber.from('1000'), price: pow18, primaryRoyaltyPercentage: BigNumber.from("150"), 
      maxPurchaseNumber: BigNumber.from('5'), reserveNumber: BigNumber.from('10'), contractURI: "", baseURI: "https://website/", payoutAddress: alice.address, alexandriaAddress: alice.address})
    await collectionCore.connect(alice).reserveMint(alice.address)
    expect(await collectionCore.balanceOf(alice.address)).to.equal(BigNumber.from('10'))
    expect(await collectionCore.totalSupply()).to.equal(BigNumber.from('10'))
  })

  it("can only reserveMint once", async () => {
    await collectionCore.initialize("Alexandria", "ALEX", {maxSupply: BigNumber.from('1000'), price: pow18, primaryRoyaltyPercentage: BigNumber.from("150"), 
      maxPurchaseNumber: BigNumber.from('5'), reserveNumber: BigNumber.from('10'), contractURI: "", baseURI: "https://website/", payoutAddress: alice.address, alexandriaAddress: alice.address})
    await collectionCore.connect(alice).reserveMint(alice.address)
    await expectRevert(collectionCore.connect(alice).reserveMint(alice.address), "already reserve minted")
  })

  it("only owner can reserveMint", async () => {
    await collectionCore.initialize("Alexandria", "ALEX", {maxSupply: BigNumber.from('1000'), price: pow18, primaryRoyaltyPercentage: BigNumber.from("150"), 
      maxPurchaseNumber: BigNumber.from('5'), reserveNumber: BigNumber.from('10'), contractURI: "", baseURI: "https://website/", payoutAddress: alice.address, alexandriaAddress: alice.address})
    await collectionCore.connect(alice).reserveMint(alice.address)
    await expectRevert(collectionCore.connect(bob).reserveMint(alice.address), "only-owner")
  })
  


})