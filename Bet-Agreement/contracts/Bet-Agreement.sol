pragma solidity 0.4.24;

contract BetAgreement {
	// Defines a type representing the organizer of the bet
	struct Organizer {
		address adr;
		uint commission;
	}
	
	Organizer public organizer; 
	uint public max_people;
	uint public people_count;
	uint public bet_price;
	uint public bet_pool;
	bool public is_bet_open;
	bool public is_bet_locked;
	mapping (address =>  uint) public bet_log;

	event BetAdded(address _from, uint _amount);
	event Refund(address _from, uint _amount);
	event BetFinalized(address _first_place, uint _first_price, address _second_place, uint _second_price, uint _organizer_commission);

	constructor(uint _commission, uint _max_people, uint _bet_price) public {
		organizer = Organizer(msg.sender, _commission);
		people_count = 0;
		max_people = _max_people;
		bet_price = _bet_price;
		is_bet_open = true;
		is_bet_locked = false;
	}

	function payBet() public payable returns (bool) {
		if (people_count >= max_people) { return false; }
		if (msg.value != bet_price) { return false; }
		if (!is_bet_open || !is_bet_locked) { return false; }  		
		bet_log[msg.sender] = msg.value;
		bet_pool += msg.value;
		people_count++;
		emit BetAdded(msg.sender, msg.value);
		return true;
	}

	function closeBet() public payable returns (bool) {
		if (msg.sender != organizer.adr) { return false; }
		is_bet_open = true;
	}

	function lockBet() public payable returns (bool) {
		if (msg.sender != organizer.adr) { return false; }
		is_bet_locked = true;
	}

	function unlockedBet() public returns (bool) {
		if (msg.sender != organizer.adr) { return false; }
		if (is_bet_open == false) { return false; }
		is_bet_locked = false;
	}

	function refund_bet(address refund_address) public payable returns (bool) {
		if (msg.sender != organizer.adr) { return false; }
		if (bet_log[refund_address] == bet_price) {
			address betAddress = this;
			if (betAddress.balance >= bet_price) {
				refund_address.transfer(bet_price);
				delete(bet_log[refund_address]);	
				people_count--;
				emit Refund(refund_address, bet_price);		
			}
		}
		return false;
	}

	function distributeBet(address firist_place, address second_place) public payable returns (bool) {
		if (msg.sender != organizer.adr) { return false; }
	}	
}
