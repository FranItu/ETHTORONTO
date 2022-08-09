// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./RentableNFT.sol";

uint256 constant MAX_MINTABLE = 1000;
uint64 constant TOKEN_EXPIRY_DAYS = 30;

contract Calliope {
  mapping(address => RentableNFT) creators;

  constructor() {

  }

  function createCollection(
    address creatorAddress,
    string memory name,
    string memory symbol,
    string memory tokenURI) public {
    RentableNFT newCollection = new RentableNFT(name, symbol);

    creators[creatorAddress] = newCollection;
    for (uint256 i = 0; i < MAX_MINTABLE; i++) {
      newCollection.mint(tokenURI);
    }
  }

  function rentFromCollection(address collection, uint256 tokenId) public {
    RentableNFT rentableNFT = RentableNFT(collection);
    bool nftAvailable = rentableNFT.userOf(tokenId) == address(0);

    require(nftAvailable,
    "This NFT is not available");

    rentableNFT.rentOut(
      tokenId,
      msg.sender,
      uint64(block.timestamp + 30 days)
    );
  }

  function getCollectionsForCreator(address creatorAddress) public {

  }
}
