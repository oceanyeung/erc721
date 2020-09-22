const token = artifacts.require("Kittycontract");

module.exports = async (deployer, network, accounts) => {
  await deployer.deploy(token);
  let kitty = await token.deployed();
};

