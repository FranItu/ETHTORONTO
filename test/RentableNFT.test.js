const helper = require('./helpers');

const RentableNFT = artifacts.require('RentableNFT');

contract('RentableNFT', (accounts) => {
  describe('Rent flow', async () => {
    // before('', async () => {
    //   await adoption.adopt(8, { from: accounts[0] });
    //   expectedAdopter = accounts[0];
    // });

    it('Does stuff', async () => {
      const rentableNFT = await RentableNFT.deployed();
      const [owner, renter] = accounts;
      await rentableNFT.mint(
        0,
        'QmPf2x91DoemnhXSZhGDP8TX9Co8AScpvFzTuFt9BGAoBY',
        { from: owner }
      );

      const ownerOf = await rentableNFT.ownerOf(0);
      expect(ownerOf).to.equal(owner);

      const expiryTimestamp = Math.round(new Date().getTime() / 1000) + 3600;
      await rentableNFT.rentOut(0, renter, expiryTimestamp);

      const renterOf = await rentableNFT.userOf(0);
      expect(renterOf).to.equal(renter);

      await helper.advanceTimeAndBlock(3601);

      const renterOf2 = await rentableNFT.userOf(0);
      expect(renterOf2).to.not.equal(renter);
      expect(renterOf2).to.equal('0x0000000000000000000000000000000000000000');
    });
  });
});
