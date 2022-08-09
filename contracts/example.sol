pragma solidity ^0.8.3;
pragma abicoder v2; // required to accept structs as function parameters
//SPDX-License-Identifier: Unlicense
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
import "hardhat/console.sol";

contract ExampleNFTMarket is Initializable, ReentrancyGuardUpgradeable, OwnableUpgradeable {
  using Counters for Counters.Counter;
  Counters.Counter private _itemsSold;

  address payable admin;
  address tokenAddress;

  function initialize() public initializer {
        admin = payable(msg.sender);
        __Ownable_init();
        __ReentrancyGuard_init();
  }

  /// @custom:oz-upgrades-unsafe-allow constructor
  constructor() initializer {}

  struct Listing {
    uint tokenId;
    string uri;
    address payable seller;
    address payable creator;
    uint256 price;
    bool isForSale;
  }

  event ListingEvent (
    uint tokenId,
    string uri,
    address seller,
    address creator,
    uint256 price,
    bool isForSale
  );

  event TokenModEvent (
    uint256 tokenId,
    bool banned
  );

  mapping(uint256 => Listing) private idListing;
  mapping(address => bool) modTeam;

  function addMod(address modAdd) public onlyOwner {
    modTeam[modAdd] = true;
  }

  function removeMod(address modAdd) public onlyOwner {
    modTeam[modAdd] = false;
  }

  function setTokenAddress(address newAddress) public onlyOwner {
    tokenAddress = newAddress;
  }

  function listTokenForSale(
    uint256 tokenId,
    uint256 price,
    string memory uri,
    address creator
  ) public payable nonReentrant {
    require(price > 0, "Price must be at least 1 wei");
    // Only allow for token owners to list items on the marketplace
    require(IERC721(tokenAddress).ownerOf(tokenId) == msg.sender, "You must own the token to list on the marketplace");
    require(idListing[tokenId].isForSale == false, "Token is already listed");

    idListing[tokenId] = Listing(
      tokenId,
      uri,
      payable(msg.sender),
      payable(creator),
      price,
      true
    );

    emit ListingEvent(tokenId, uri, msg.sender, creator, price, true);
  }

   function editListing(
    uint256 tokenId,
    uint256 price,
    string memory uri,
    address creator) 
    public payable nonReentrant {
    require(IERC721(tokenAddress).ownerOf(tokenId) == msg.sender, "Must be owner");
    require(idListing[tokenId].isForSale == true, "Token is not listed");

    idListing[tokenId] = Listing(
      tokenId,
      uri,
      payable(msg.sender),
      payable(creator),
      price,
      true
    );

    emit ListingEvent(tokenId, uri, msg.sender, creator, price, true);
  }

  function cancelListing(uint256 tokenId) public payable nonReentrant {
    require(IERC721(tokenAddress).ownerOf(tokenId) == msg.sender, "Must be owner");
    require(idListing[tokenId].isForSale == true, "Token is not listed");
    idListing[tokenId].isForSale = false;
    emit ListingEvent(tokenId, idListing[tokenId].uri, msg.sender, idListing[tokenId].creator, idListing[tokenId].price, false);
  }

  function sellToken(
    uint256 tokenId
    ) public payable nonReentrant {
    uint price = idListing[tokenId].price;
    require(msg.value == price, "Please submit the asking price in order to complete the purchase");
    require(idListing[tokenId].isForSale == true, "Token is not listed");
    require(IERC721(tokenAddress).ownerOf(tokenId) == idListing[tokenId].seller, "Must be owner");
    IERC721(tokenAddress).transferFrom(idListing[tokenId].seller, msg.sender, tokenId);

    uint numSeller = 925;
    uint numAdmin = 25;
    uint numCreator = 50;

    uint percentageSeller = msg.value * numSeller / 1000;
    uint percentageCreator = msg.value * numCreator / 1000;
    uint percentageAdmin = msg.value * numAdmin / 1000;
    
    idListing[tokenId].seller.transfer(percentageSeller);
    idListing[tokenId].creator.transfer(percentageCreator);
    admin.transfer(percentageAdmin);

    idListing[tokenId].seller = payable(msg.sender);
    idListing[tokenId].isForSale = false;
    _itemsSold.increment();
    emit ListingEvent(tokenId, idListing[tokenId].uri, idListing[tokenId].seller, idListing[tokenId].creator, 0, false);
  }

  // Initial implementation to moderate the platform.
  // Not planned for long term use, only while the Mod tools are being built and the beta is running
  function banToken(uint256 tokenId) public {
    require(modTeam[msg.sender], "You are not a moderator");
    emit TokenModEvent(tokenId, true);
  }

  function unbanToken(uint256 tokenId) public {
    require(modTeam[msg.sender], "You are not a moderator");
    emit TokenModEvent(tokenId, false);
  }
}

contract ExampleNFT is ERC721URIStorage, EIP712, AccessControl, Ownable {
  using Counters for Counters.Counter;
  // bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
  string private constant SIGNING_DOMAIN = "ExampleNFT-Voucher";
  string private constant SIGNATURE_VERSION = "1";
  Counters.Counter private _tokenIds;
  address contractAddress;
  
  address payable admin;
  bool mintingIsOpen;
  bool onlyWhitelist;

  constructor(address marketplaceAddress)
    ERC721("ExampleNFT", "TOR") 
    EIP712(SIGNING_DOMAIN, SIGNATURE_VERSION) {
      admin = payable(msg.sender);
      contractAddress = marketplaceAddress;
      mintingIsOpen = false;
      onlyWhitelist = true;
    }

  struct NFTVoucher {
    uint256 tokenId;
    uint256 minPrice;
    string uri;
    bytes signature;
    address creator;
  }

   event VoucherEvent (
    uint256 tokenId,
    uint256 minPrice,
    string uri,
    bytes signature,
    address creator
  );

  mapping(uint256 => NFTVoucher) private idVoucher;
  mapping(address => bool) whitelistedAddresses;
  mapping(address => bool) modTeam;

  function addMod(address modAdd) public onlyOwner {
    modTeam[modAdd] = true;
  }

  function removeMod(address modAdd) public onlyOwner {
    modTeam[modAdd] = false;
  }

  function addUser(address _addressToWhitelist) public {
    require(modTeam[msg.sender], "You are not a moderator");
    whitelistedAddresses[_addressToWhitelist] = true;
  }

  function removeUser(address _addressToWhitelist) public {
    require(modTeam[msg.sender], "You are not a moderator");
    whitelistedAddresses[_addressToWhitelist] = false;
  }

  function verifyUser(address _whitelistedAddress) public view returns(bool) {
    bool userIsWhitelisted = whitelistedAddresses[_whitelistedAddress];
    return userIsWhitelisted;
  }

  function setMintingOpen() public onlyOwner {
    mintingIsOpen = true;
  }

  function setMintingClosed() public onlyOwner {
    mintingIsOpen = false;
  }

  function setOnlyWhitelist() public onlyOwner {
    onlyWhitelist = true;
  }

  function setNotOnlyWhitelist() public onlyOwner {
    onlyWhitelist = false;
  }

  function logVoucher(NFTVoucher calldata voucher) public {
    require(mintingIsOpen == true, "Minting is currently closed");

    if(onlyWhitelist) {
      require(whitelistedAddresses[msg.sender], "You need to be whitelisted");
    }
    _verify(voucher);
    _tokenIds.increment();
    idVoucher[voucher.tokenId] = NFTVoucher(
      voucher.tokenId, voucher.minPrice, voucher.uri, voucher.signature, voucher.creator
    );
    emit VoucherEvent(voucher.tokenId, voucher.minPrice, voucher.uri, voucher.signature, voucher.creator);
  }

  function editVoucherPrice(NFTVoucher calldata voucher) public {
    require(voucher.creator == msg.sender);
    require(voucher.creator == idVoucher[voucher.tokenId].creator);
    if(onlyWhitelist) {
      require(whitelistedAddresses[msg.sender], "You need to be whitelisted");
    }
    _verify(voucher);
     idVoucher[voucher.tokenId] = NFTVoucher(
      voucher.tokenId, voucher.minPrice, voucher.uri, voucher.signature, voucher.creator
    );
    emit VoucherEvent(voucher.tokenId, voucher.minPrice, voucher.uri, voucher.signature, voucher.creator);
  }

  function fetchNextTokenId() external view returns (uint) {
    uint256 newItemId = _tokenIds.current() + 1;
    return newItemId;
  }

  function createToken(string memory tokenURI) public returns (uint) {
      require(mintingIsOpen == true, "Minting is currently closed");
      if(onlyWhitelist) {
        require(whitelistedAddresses[msg.sender], "You need to be whitelisted");
      }
      _tokenIds.increment();
      uint256 newItemId = _tokenIds.current();

      _mint(msg.sender, newItemId);
      _setTokenURI(newItemId, tokenURI);
      setApprovalForAll(contractAddress, true);
      return newItemId;
    }


  /// Redeems an NFTVoucher for an actual NFT, creating it in the process.
  /// @param redeemer The address of the account which will receive the NFT upon success.
  /// @param voucher A signed NFTVoucher that describes the NFT to be redeemed.
  function redeem(address redeemer, NFTVoucher calldata voucher) public payable returns (uint256) {
    // _tokenIds.increment();
    
    // make sure signature is valid and get the address of the signer
    address signer = _verify(voucher);
    uint256 newItemId = voucher.tokenId;
    // make sure that the redeemer is paying enough to cover the buyer's cost
    require(msg.value >= voucher.minPrice, "Insufficient funds to redeem");

    // first assign the token to the signer, to establish provenance on-chain
    _mint(signer, newItemId);
    _setTokenURI(newItemId, voucher.uri);
    setApprovalForAll(contractAddress, true);
    // transfer the token to the redeemer
    _transfer(signer, redeemer, newItemId);


    address payable receiver = payable(voucher.creator);

    uint numSeller = 975;
    uint numAdmin = 25;

    uint percentageReciever = msg.value * numSeller / 1000;
    uint percentageAdmin = msg.value * numAdmin / 1000;
   
    receiver.transfer(percentageReciever);
    admin.transfer(percentageAdmin);

    return voucher.tokenId;
  }

  /// Returns a hash of the given NFTVoucher, prepared using EIP712 typed data hashing rules.
  /// @param voucher An NFTVoucher to hash.
  function _hash(NFTVoucher calldata voucher) internal view returns (bytes32) {
    return _hashTypedDataV4(keccak256(abi.encode(
      keccak256("NFTVoucher(uint256 tokenId,uint256 minPrice,string uri,address creator)"),
      voucher.tokenId,
      voucher.minPrice,
      keccak256(bytes(voucher.uri)),
      voucher.creator
    )));
  }

  /// Returns the chain id of the current blockchain.
  /// @dev This is used to workaround an issue with ganache returning different values from the on-chain chainid() function and
  ///  the eth_chainId RPC method. See https://github.com/protocol/nft-website/issues/121 for context.
  function getChainID() external view returns (uint256) {
    uint256 id;
    assembly {
        id := chainid()
    }
    return id;
  }


  

  /// Verifies the signature for a given NFTVoucher, returning the address of the signer.
  /// @dev Will revert if the signature is invalid. Does not verify that the signer is authorized to mint NFTs.
  /// @param voucher An NFTVoucher describing an unminted NFT.
  function _verify(NFTVoucher calldata voucher) internal view returns (address) {
    bytes32 digest = _hash(voucher);
    return ECDSA.recover(digest, voucher.signature);
  }

  function supportsInterface(bytes4 interfaceId) public view virtual override (AccessControl, ERC721) returns (bool) {
    return ERC721.supportsInterface(interfaceId) || AccessControl.supportsInterface(interfaceId);
  }
}
