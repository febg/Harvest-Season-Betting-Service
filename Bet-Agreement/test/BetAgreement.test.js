let BetAgreement = artifacts.require("./BetAgreement.sol");

contract("BetAgreement", async accounts => {
	it("shoud assert a new Bet Owner instance", async () => {
		let betAgreement = await BetAgreement.deployed();
		let organizer = await betAgreement.organizer.call();
		assert(organizer[0], accounts[0], "organizer address was not set correctly");
		assert(organizer[1], 2, "organizer's commission was not set correctly");
	})
})
