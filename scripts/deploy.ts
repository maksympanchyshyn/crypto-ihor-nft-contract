import { ethers } from 'hardhat';

async function main() {
  const CryptoIhorNFT = await ethers.getContractFactory('CryptoIhorNFT');
  const cryptoIhorNFT = await CryptoIhorNFT.deploy();

  await cryptoIhorNFT.deployed();

  console.log('CryptoIhorNFT deployed to:', cryptoIhorNFT.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
