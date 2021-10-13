/**
 * Test rely on the Punk contract. This contract should be deployed first
 * After deployment of the contract the deployer should fund the IBCO contract with 50_000_000e18 wei
 */

const { assert } = require('chai');

const IBCO = artifacts.require('PunkIBCO');

contract('PunkIBCO', function (accounts) {
  let contract;
  const startTime = 1634141102;

  it('should deploy', async function () {
    IBCO.deployed()
      .then((response) => {
        contract = response;
        assert.isTrue(true);
      })
      .catch((responseError) => {
        assert.isTrue(false);
      });
  });

  it('should have a correct owner', async function () {
    const owner = await contract.owner();

    assert.equal(owner, accounts[0], 'Wrong owner');
  });

  it('should have a correct startTime', async function () {
    // see 1_initial_migration.js
    const duration = 600; // see 1_initial_migration.js

    const startTimeBN = await contract.startTime();
    const endTimeBN = await contract.endTime();

    assert.equal(startTime, startTimeBN.toNumber(), 'Wrong startTime');
    assert.equal(startTime + duration, endTimeBN.toNumber(), 'Wrong endTime');
  });

  it('should allow to receive funds for IBCO', async function () {
    await web3.eth.sendTransaction({
      to: contract.address,
      from: accounts[1],
      value: web3.utils.toWei('1'),
    });

    await web3.eth.sendTransaction({
      to: contract.address,
      from: accounts[1],
      value: web3.utils.toWei('2'),
    });

    const provided = await contract.provided(accounts[1]);

    assert.equal(
      web3.utils.toWei('3'),
      provided.toString(),
      'Provided amount not equal'
    );
  });

  it('should allow withdraw of funds to contract owner', async function () {
    const BN = web3.utils.BN;

    const preBalance = await web3.eth.getBalance(accounts[0]);
    const tx = await contract.withdraw();
    const afterBalance = await web3.eth.getBalance(accounts[0]);

    // console.log(preBalance);
    // console.log(afterBalance);

    assert.isTrue(preBalance < afterBalance);
  });

  it('should disallow to let participants claim tokens when IBCO is runnning', async function () {
    contract
      .claim({ from: accounts[1] })
      .then((response) => {
        assert.isTrue(false);
      })
      .catch((responseError) => {
        assert.isTrue(true);
      });
  });

  it('should allow the owner to update time', async function () {
    //
    const tx = await contract.updateFundraisingTime(10, startTime - 1000);
    const startTimeBN = await contract.startTime();

    // console.log(startTime);
    // console.log(startTimeBN.toNumber());

    assert.equal(startTimeBN.toNumber(), startTime - 1000);
  });

  it('should allow to let participants claim tokens when IBCO has ended', async function () {
    contract
      .claim({ from: accounts[1] })
      .then((response) => {
        assert.isTrue(true);
      })
      .catch((responseError) => {
        assert.isTrue(false);
      });
  });
});
