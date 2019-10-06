const Migrations = artifacts.require("splitwise");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};
