var BetAgreement = artifacts.require("./BetAgreement.sol");

module.exports = function(deployer) {
  deployer.deploy(BetAgreement, 2, 5, 10);
};
