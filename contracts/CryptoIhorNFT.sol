// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract CryptoIhorNFT is ERC721, Ownable {
  uint256 public mintPrice;
  uint256 public totalSupply;
  uint256 public maxSupply;
  uint256 public maxPerWallet;

  bool public isPublicMintEnabled;
  string internal baseTokenUri;
  address payable public withdrawWallet;

  mapping(address => uint256) public walletMints;

  constructor() payable ERC721('CryptoIhor', 'CI') {
    mintPrice = 0.02 ether;
    totalSupply = 0;
    maxSupply = 1000;
    maxPerWallet = 3;
    withdrawWallet = payable(0x1c67ca825f6CCEe24a7d7136f7F1A9A1df03738C);
  }

  function setIsPublicMintEnabled(bool _isPublicMintEnabled) external onlyOwner {
    isPublicMintEnabled = _isPublicMintEnabled;
  }

  function setBaseTokenUri(string calldata _baseTokenUri) external onlyOwner {
    baseTokenUri = _baseTokenUri;
  }

  function tokenURI(uint256 _tokenId) public view override returns (string memory) {
    require(_exists(_tokenId), 'Token does not exists!');
    return string(abi.encodePacked(baseTokenUri, Strings.toString(_tokenId), '.json'));
  }

  function withdraw() external onlyOwner {
    (bool success, ) = withdrawWallet.call{value: address(this).balance}('');
    require(success, 'withdraw failed');
  }

  function mint(uint256 _quantity) public payable {
    uint256 mints = walletMints[msg.sender];

    require(isPublicMintEnabled, 'Minting not enabled');
    require(msg.value == _quantity * mintPrice, 'Wrong mint value');
    require(totalSupply + _quantity <= maxSupply, 'Sold out');
    require(mints + _quantity <= maxPerWallet, 'Exceed max mints');

    for (uint256 i = 0; i < _quantity; i++) {
      uint256 newTokenId = totalSupply + 1;
      totalSupply++;
      walletMints[msg.sender] = mints + 1;
      _safeMint(msg.sender, newTokenId);
    }
  }
}
