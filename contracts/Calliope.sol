// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./RentableNFT";

uint256 constant MAX_MINTABLE = 1000;
uint64 constant TOKEN_EXPIRY_DAYS = 30;

contract Calliope {
  mapping(address => RentableNFT[]) creators

  constructor() {

  }

  function createCollection(
    address creatorAddress,
    string memory name,
    string memory symbol,
    string memory tokenURI) {
    RentableNFT storage newCollection = new RentableNFT(name, symbol);
    creators[creatorAddress].push(newCollection);

    for (uint256 i = 0; i < MAX_MINTABLE; i++) {
      newCollection.mint(tokenURI);
    }
  }

  function rentFromCollection(address collection) {
    uint256 firstAvailableTokenId = -1;
    RentableNFT rentableNFT = RentableNFT(collection)

    for (uint256 i = 0; i < MAX_MINTABLE; i++) {
      if (rentableNFT.userOf(i) == address(0)) {
        firstAvailableTokenId = i;
      }
    }

    require(firstAvailableTokenId > 0,
    "No NFTs available for rent in collection");

    rentableNFT.rentOut(
      firstAvailableTokenId,
      msg.sender,
      now + TOKEN_EXPIRY_DAYS days
    );
  }

  function getCollectionsForCreator(address creatorAddress) {

  }
}
