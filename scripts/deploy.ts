// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');
  const [owner] = await ethers.getSigners();
  // We get the contract to deploy
  const Token = await ethers.getContractFactory("Token");
  const token = await Token.deploy("1000000000000000000000000");

  await token.deployed();

  console.log("Token deployed to:", token.address);

  const Merkle = await ethers.getContractFactory("MerkleAirdrop");
  const merkle = await Merkle.deploy(token.address);

  await merkle.deployed();

  console.log("Merkle Contract deployed to:", merkle.address);

  await merkle.claimForAddress(
    0,
    0,
    "1000000000000000000000000",
    ["0x001Daa61Eaa241A8D89607194FC3b1184dcB9B4C"],
    "0x00"
  );
  console.log(transactionHash);
}


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
