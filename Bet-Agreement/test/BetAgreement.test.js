let BetAgreement = artifacts.require("./BetAgreement.sol");

contract("BetAgreement", async accounts => {
	it("shoud assert a new Bet Owner instance", async () => {
		let betAgreement = await BetAgreement.deployed();
		let organizer = await betAgreement.organizer.call();
		let max_people = await betAgreement.max_people.call();
		let bet_price = await betAgreement.bet_price.call();
		assert(organizer[0], accounts[0], "organizer address was not set correctly");
		assert(organizer[1], 2, "organizer's commission was not set correctly");
		assert(max_people, 5, "max_people was not set correctly");
		assert(bet_price, 10, "bet_price was not set correctly");
	})

	it("shoud correctly pay for a new bet", async () => {
		let account_one = accounts[1];
		let betAgreement = await BetAgreement.deployed();
		let bet_price = await betAgreement.bet_price.call();
		let ticket_price = bet_price;
		let starting_bet_pool = await betAgreement.bet_pool.call();
		let starting_people_count = await betAgreement.people_count.call();
		let starting_contract_balance = web3.eth.getBalance(betAgreement.address);
		let starting_account_one_balance = web3.eth.getBalance(account_one);
		
		let bet = await betAgreement.payBet({from: account_one, value: ticket_price}); 
		
		let bet_log = betAgreement.bet_log.call(account_one);
		let ending_bet_pool = await betAgreement.bet_pool.call();
		let ending_people_count = await betAgreement.people_count.call();
		let ending_contract_balance = web3.eth.getBalance(betAgreement.address);
		let ending_account_one_balance = web3.eth.getBalance(account_one);
		assert(bet, true, "Bet did not placed");
		assert(ending_bet_pool, starting_bet_pool + ticket_price, "bet money was not added to pool creectly");
		assert(ending_people_count, starting_people_count + 1, "people count was not incremented");
		assert(ending_contract_balance, starting_contract_balance + ticket_price, "bet money was not transfered");
		assert(bet_log, ticket_price, "bet money was not recorded successfully");
		assert(ending_account_one_balance, starting_account_one_balance - ticket_price, "bet was not charged correctly");
	})
})
