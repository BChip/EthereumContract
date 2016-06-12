contract SimpleAuction {
    // Parameters of the auction. Times are either
    // absolute unix timestamps (seconds since 1970-01-01)
    // or time periods in seconds.
    address public contractOwner;
    uint public numBets;
    uint public maxBet;
    // Current state of the auction.
    //address public highestBidder;
    //uint public highestBid;
    address public winnerAddr;
    address public gamblers;

    // Allowed withdrawals of previous bids
    //mapping(address => uint) pendingReturns;

    // Set to true at the end, disallows any change
    bool ended;

    // Events that will be fired on changes.
    //event HighestBidIncreased(address bidder, uint amount);
    //event AuctionEnded(address winner, uint amount);
    event submittedGamble(address gambler, uint amount);
    event gamblingEnded(address winner, uint amount);

    // The following is a so-called natspec comment,
    // recognizable by the three slashes.
    // It will be shown when the user is asked to
    // confirm a transaction.

    /// Create a simple auction with `_biddingTime`
    /// seconds bidding time on behalf of the
    /// beneficiary address `_beneficiary`.
    /* function SimpleAuction(uint _biddingTime, address _beneficiary) {
        beneficiary = _beneficiary;
        auctionStart = now;
        biddingTime = _biddingTime;
    } */
    function gamblingEvent(address _winner, address _contractOwner, _maxBet){
        contractOwner = _contractOwner;
        numBets = 0;
        maxBet = _maxBet;
    }

    /// Bid on the auction with the value sent
    /// together with this transaction.
    /// The value will only be refunded if the
    /// auction is not won.
    function bid() {
        // No arguments are necessary, all
        // information is already part of
        // the transaction.
        if (numBets > 10) {
            // Revert the call if the bidding
            // period is over.
            throw;
        }
        /* if (msg.value <= highestBid) {
            // If the bid is not higher, send the
            // money back.
            throw;
        } */
        /* if (highestBidder != 0) {
            // Sending back the money by simply using
            // highestBidder.send(highestBid) is a security risk
            // because it can be prevented by the caller by e.g.
            // raising the call stack to 1023. It is always safer
            // to let the recipient withdraw their money themselves.
            pendingReturns[highestBidder] += highestBid;
        } */
        if (msg.value != maxBet){
            throw;
        }
        /* highestBidder = msg.sender;
        highestBid = msg.value; */
        HighestBidIncreased(msg.sender, msg.value);
        numBets = numBets + 1;
    }

    /// Withdraw a bid that was overbid.
    /* function withdraw() {
        var amount = pendingReturns[msg.sender];
        // It is important to set this to zero because the recipient
        // can call this function again as part of the receiving call
        // before `send` returns.
        pendingReturns[msg.sender] = 0;
        if (!msg.sender.send(amount))
            throw; // If anything fails, this will revert the changes above
    } */

    /// End the auction and send the highest bid
    /// to the beneficiary.
    function auctionEnd() {
        if (numBets <= 10)
            throw; // auction did not yet end
        if (ended)
            throw; // this function has already been called
        gamblingEnded(highestBidder, highestBid);

        if (!beneficiary.send(highestBid))
            throw;
        ended = true;
    }

    function () {
        // This function gets executed if a
        // transaction with invalid data is sent to
        // the contract or just ether without data.
        // We revert the send so that no-one
        // accidentally loses money when using the
        // contract.
        throw;
    }
}
