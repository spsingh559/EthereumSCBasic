pragma solidity ^0.4.24;

contract Auction{
    
    address public owner;
    uint public startBlock;
    uint public endBlock;
    string public ipfsHash;
    uint public bidIncrement;
    enum State {Started,Running,Ended,Canceled}
    State public autionState;

    uint public highestBindingBid;
    address public highestBidder;
    
    mapping(address=>uint) public bids;
    
    constructor()public{
        owner=msg.sender;
        startBlock=block.number; // current block number
        endBlock=startBlock+40320; // each 15 seond 1 block get created,
        //so if time duration is for two weeks, 40320 blocks get created.
        ipfsHash=""; // store the information about asset for which auction is going on
        bidIncrement=1 ether;
        autionState=State.Running;
    }
    
    modifier notOwner (){
        require(msg.sender!=owner);
        _;
    }
    
    modifier afterStart(){
        require(block.number>=startBlock);
        _;
    }
    modifier beforeEnd(){
        require(block.number<=endBlock);
        _;
    }
    
    modifier onlyOwner(){
        require(msg.sender==owner);
        _;
    }
    
    //pure function is needed when few operation need not to be done through EVM
    function min(uint a, uint b) pure internal returns(uint){
        if(a<b){
            return a;
        }else{
            return b;
        }
    }
    
    function placeBid() public payable notOwner afterStart beforeEnd returns(bool){
        require(autionState==State.Running);
        require(msg.value>=0.01 ether);
        uint currentBid=bids[msg.sender]+ msg.value; // add previous balance + additional balance
        require(currentBid >highestBindingBid); //user bid should be atleast grreater than binding bid
        bids[msg.sender]=currentBid; // if yes, add the new balance to user
        if(currentBid<bids[highestBidder]){ //check currentBid vs highest bidder
            highestBindingBid=min(currentBid+bidIncrement,bids[highestBidder]);
        }else{
            highestBindingBid=min(currentBid,bids[highestBidder]+bidIncrement);
            highestBidder=msg.sender;
            
        }
        return true;
    }
    
    function cancelBid() public {
        autionState =State.Canceled;
    }
    
    function finaliseAuction() public view{
        require(autionState==State.Canceled || block.number>endBlock);
        // either auction has been Canceledor or two week time limit is over
    require(msg.sender==owner || bids[msg.sender]>0);
    // two people can only finalise, either owner or bidder
    address rec;
    uint value;
    
    if(autionState==State.Canceled){ // when event itself got Canceled
        rec=msg.sender;
        value=bids[msg.sender];
    }else{ // event was not Canceled
        if(msg.sender==owner){
            rec=owner;
            value=highestBindingBid;
        }else if(msg.sender==highestBidder){//neither owner, but highest bidder
            rec=highestBidder;
            value=bids[highestBidder]-highestBindingBid;
        }else{ // auction aparticipent
            rec=msg.sender;
            value=bids[msg.sender];
        }
    }
    
        
    }
    
}