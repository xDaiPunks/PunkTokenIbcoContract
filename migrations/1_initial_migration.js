const PunkIBCO = artifacts.require('PunkIBCO');

const startTime = 1634141102;
const duration = 600;
const contractAddress = '0xDB2a4Df88a3a5a3Ca1aDe9F3303Bb4fC98DefE35';

module.exports = function (deployer) {
  deployer.deploy(PunkIBCO, contractAddress, duration, startTime, { gas: 5000000 });
};