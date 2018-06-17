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
	mapping (uint => uint) public position_price;
	mapping (address =>  uint) public bet_log;

	constructor(uint _commission) public {
		organizer = Organizer(msg.sender, _commission);
	}
	
}
