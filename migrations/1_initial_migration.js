
//  const Migrations = artifacts.require("Migrations");
const CLAP = artifacts.require("ClapArt");

const OWNER_ADDRESS = "";

module.exports = async function (deployer) {
  await deployer.deploy(CLAP, OWNER_ADDRESS);
};