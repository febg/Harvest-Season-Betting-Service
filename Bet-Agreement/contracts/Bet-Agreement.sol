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
	mapping (uint => uint) public position_price;
	mapping (address =>  uint) public bet_log;

	event Payment(address _from, uint _amount);

	constructor(uint _commission, uint _max_people, uint _bet_price) public {
		organizer = Organizer(msg.sender, _commission);
		people_count = 0;
		max_people = _max_people;
		bet_price = _bet_price;
	}

	function payBet() public payable returns (bool) {
		if (people_count >= max_people) { return false; }
		if (msg.value != bet_price) { return false; } 		
		bet_log[msg.sender] = msg.value;
		bet_pool += msg.value;
		people_count++;
		emit Payment(msg.sender, msg.value);
		return true;
	}

	function closeBet() public payable returns (bool) {
		if (msg.sender != organizer.adr) { return false; }
	}

	function lockBet() public payable returns (bool) {
		if (msg.sender != organizer.adr) { return false; }
	}

	function refund() public payable returns (bool) {
		if (msg.sender != organizer.adr) { return false; }
	}	
}
