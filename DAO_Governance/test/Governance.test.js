const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

exports.proposalStates = {
  pending: 0,
  active: 1,
  canceled: 2,
  quorumFailed: 3,
  defeated: 4,
  succeeded: 5,
  queued: 6,
  expired: 7,
  executed: 8
}

exports.advanceBlocks = async function (blocks) {
  console.log(`Advancing blocks: ${blocks} ...`);
  for (let i = 0; i <= blocks; i++) {
    ethers.provider.send("evm_mine");
  }
}

describe("Lock2", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployOneYearLockFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();
    // const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
    // const ONE_GWEI = 1_000_000_000;
    // const lockedAmount = ONE_GWEI;
    // const unlockTime = (await time.latest()) + ONE_YEAR_IN_SECS;
    // const Lock = await ethers.getContractFactory("Lock");
    // const lock = await Lock.deploy(unlockTime, { value: lockedAmount });

    const DAOToken = await ethers.getContractFactory("DAOToken");
    const daoToken = await DAOToken.deploy(owner.address);
    console.log("Timelock Address", daoToken.target);

    // console.log((await daoToken.balanceOf(owner.address)))

    const Timelock = await ethers.getContractFactory("Timelock");
    const timelock = await Timelock.deploy(owner.address, '2')
    console.log("Timelock Address", timelock.target);

    const Governor = await ethers.getContractFactory("Governor");
    const governor = await Governor.deploy(timelock.target, daoToken.target, owner.address);
    console.log("Governer Address ", governor.target);

    await daoToken
      .connect(owner)
      .setGovernor(governor.target);

    await timelock
      .connect(owner)
      .setPendingAdmin(governor.target);

    await governor
      .connect(owner)
      .__acceptAdmin();

    return { daoToken, owner, timelock, governor };

    // return { lock, unlockTime, lockedAmount, owner, otherAccount };
  }

  // it("should pass if 3/4 of token holders vote yes on a proposal", async function () {

  describe("Deployment", function () {
    it("Should set the right unlockTime", async function () {
      const { daoToken, owner, timelock, governor } = await loadFixture(deployOneYearLockFixture);
      const [dealer1, dealer2, dealer3, dealer4] = await ethers.getSigners();

      // transfer DAO tokens to all holders
      const balance = BigInt(await daoToken.balanceOf(owner.address))
      let quarterOfSupply = (balance / BigInt(4));
      console.log(quarterOfSupply)
      await daoToken
        .connect(owner)
        .transfer(dealer1.address, quarterOfSupply);

      const balanceCheck = BigInt(await daoToken.balanceOf(dealer1.address))
      console.log(balanceCheck)

      await daoToken
        .connect(owner)
        .transfer(dealer2.address, quarterOfSupply);
      const balanceCheck2 = BigInt(await daoToken.balanceOf(dealer2.address))
      console.log(balanceCheck2)

      await daoToken
        .connect(owner)
        .transfer(dealer3.address, quarterOfSupply);
      const balanceCheck3 = BigInt(await daoToken.balanceOf(dealer3.address))
      console.log(balanceCheck3)

      await daoToken
        .connect(owner)
        .transfer(dealer4.address, quarterOfSupply);
      const balanceCheck4 = BigInt(await daoToken.balanceOf(dealer4.address))
      console.log(balanceCheck4)

      let proposal = await createProposal({
        proposer: dealer1,
        deployer: owner,
        governor: governor,
        tokenTypeId: 1
      });

      console.log("proposal Id", proposal)
      await governor.state(proposal).then((response) => {
        expect(response).to.equal(exports.proposalStates.active);
      });

      // await governor.getReceipt(proposal, dealer1).then((response) => {
      //   expect(response.rawVotes).to.equal("100000000000000000000000");
      //   expect(response.votes).to.equal(
      //     Math.floor(Math.sqrt(100000000000000000000000))
      //   );
      // });

      // cast two more yes votes and one no vote
      await governor
        .connect(dealer2)
        .castVote(proposal, true, quarterOfSupply);
      await governor
        .connect(dealer3)
        .castVote(proposal, true, quarterOfSupply);
      await governor
        .connect(dealer4)
        .castVote(proposal, false, quarterOfSupply);

      // check dclm8 balances after vote
      await daoToken.balanceOf(dealer2).then((response) => {
        expect(response).to.equal("0");
      });
      await daoToken.balanceOf(dealer3).then((response) => {
        expect(response).to.equal("0");
      });
      await daoToken.balanceOf(dealer4).then((response) => {
        expect(response).to.equal("0");
      });

      await exports.advanceBlocks(10);

      // check for success
      await governor.state(proposal).then((response) => {
        expect(response).to.equal(exports.proposalStates.succeeded);
      });

      // queue proposal after it's successful
      let queueProposal = await governor.connect(owner).queue(proposal);
      expect(queueProposal);

      await exports.advanceBlocks(49);

      let executeProposal = await governor
        .connect(owner)
        .execute(proposal);
      expect(executeProposal);
    });
  });

});

const createProposal = async function (params) {
  // set-up parameters for proposal external contract call
  let proposalCallParams = {
    accountBy: params.deployer,
    accountFrom: params.deployer,
    proposer: params.proposer,
    tokenTypeId: params.tokenTypeId || 1,
    quantity: 300,
    fromDate: 0,
    thruDate: 0,
    metadata: "metadata",
    manifest: "manifest",
    description: "description",
  };

  // set-up proposal parameters
  let proposal = {
    targets: ["0x8B801270f3e02eA2AACCf134333D5E5A019eFf42"], // contract to call => Random data
    values: [0], // number of wei sent with call, i.e. msg.value
    signatures: [
      "issueOnBehalf(address,uint160,address,uint8,uint256,uint256,uint256,string,string,string)",
    ], // function in contract to call => Random 
    calldatas: ["0x68656c6c6f"],
    description: "Test proposal", // description of proposal
  };

  // make proposal
  let makeProposal = await params.governor
    .connect(params.proposer)
    .propose(
      proposal.targets,
      proposal.values,
      proposal.signatures,
      proposal.calldatas,
      proposal.description
    );

  console.log("proposal created!")
  // get ID of proposal just made, find the corresponding event
  let proposalTransactionReceipt = await makeProposal.wait(0);
  // let proposalId = getProposalIdFromProposalTransactionReceipt(proposalTransactionReceipt);
  // console.log("proposal Id ", proposalId);
  let proposalId = 1;
  // verify details of proposal
  await params.governor.getActions(1).then((response) => {
    expect(response.targets).to.deep.equal(proposal.targets);
    // @TODO: response.values seems to return a function rather than a value, so check this against proposal.values
    expect(response.signatures).to.deep.equal(proposal.signatures);
    expect(response.calldatas).to.deep.equal(proposal.calldatas);
  });

  // try to execute proposal before it's been passed
  let errMsg = null;
  try {
    await params.governor
      .connect(await ethers.getSigner(params.deployer))
      .execute(1);
  } catch (err) {
    errMsg = err.toString();
  }
  // get proposal state
  await params.governor.state(proposalId).then((response) => {
    expect(response).to.equal(exports.proposalStates.pending);
  });

  await exports.advanceBlocks(1);

  // get proposal state
  await params.governor.state(proposalId).then((response) => {
    expect(response).to.equal(exports.proposalStates.active);
  });

  return proposalId;
};
