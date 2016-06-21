contract gamblingEvent {

    address public contractOwner;
    uint public numBets;
    uint public maxBet;

    address[] addresses;
    uint[] numbers;
    uint oldNumber = 0;
    address winner;
    uint houseAmount;

    struct Gambler{
    	bool gambled;
    };

    mapping(address => Gambler) gamblers;

    bool ended;

    event betSubmit(address gambler, uint amount);
    event gamblingEnd(address winner, uint amount);

    function gamblingEvent(_maxBet){
        contractOwner = msg.sender;
        numBets = 0;
        maxBet = _maxBet;
    }

    function bid() {
    	Gambler sender = gamblers[msg.sender];
        if (sender.gambled) throw;

        if (ended) throw;
     
        if (msg.value != maxBet) throw;

        sender.gambled = true;
        addresses.push(msg.sender);

        numbers.push(uint8(sha3(mulmod((now+uint(tx.origin)), (block.number+msg.value+tx.gasprice), 
        	(uint(msg.sender)+block.number+block.difficulty))));) 

        betSubmit(msg.sender, msg.value);
        numBets = numBets + 1;
        if(numBets == 10){
        	for(uint x = 0; x<addresses.length; x++){
	            if(numbers[x]>oldNumber){
	                winner = addresses[x];
	                oldNumber = numbers[x];
	            }
            
        	}
	        houseAmount = this.balance / 2000;
	        owner.send(houseAmount);
	        winner.send(this.balance);
	        gamblingEnded();
        }
    }


    function gamblingEnded() {
        if (numBets < 10)
            throw;
        if (ended)
            throw; 
        gamblingEnd(highestBidder, highestBid);

        ended = true;
    }

    function () {
        throw;
    }
}


