const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying TimeLockedSavings contract with account:", deployer.address);

  const TimeLockedSavings = await hre.ethers.getContractFactory("TimeLockedSavings");
  const timeLockedSavings = await TimeLockedSavings.deploy();

  await timeLockedSavings.deployed();

  console.log("TimeLockedSavings deployed to:", timeLockedSavings.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
