var RentableNFT = artifacts.require('RentableNFT');
var Calliope = artifacts.require('Calliope');

module.exports = function (deployer) {
  deployer.deploy(RentableNFT, 'Calliope', 'CAL');
};
