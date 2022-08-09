var RentableNFT = artifacts.require('RentableNFT');

module.exports = function (deployer) {
  deployer.deploy(RentableNFT, 'Calliope', 'CAL');
};
