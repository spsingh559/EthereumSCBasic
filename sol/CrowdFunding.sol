pragma solidity ^0.4.24;

contract FundRaising{
 mapping (address => uint) public contributor; //key is address and value is amount
 address public admin;
 uint public noOfContributors;
 uint public minContribution;
 uint public deadline;
 uint public goal;
 uint public raisedAmount;
 
 //createing Request struct for voting
 struct Request{
     string desc;
     address rec;
     uint value;
     bool completed;
     uint noOfVoters;
     mapping(address => bool) voters; //check the status of contributor votes
 }
 
 Request[] public requests; //list of struct
 
 event ContributeEvent(address sender,uint value);
 event CreateRequestEvent (string _desc, address _rec,uint _value);
 event PaymentEvent(address _rec,uint value);
 constructor(uint _goal, uint _deadline) public{
     goal=_goal;
     deadline=now + _deadline; // current seconds + extended
     admin=msg.sender;
     minContribution=10;
 }
 
 function contribute() public payable { //this function rec fund
     require(now<deadline); // contribute contract should be active
     require(msg.value>=minContribution); // should be more than minContribution
     if(contributor[msg.sender]==0){
         noOfContributors++; // first time contributor has to be added into list only
     }
     contributor[msg.sender]+=msg.value; // adding existing balance with new one
     raisedAmount+=msg.value;
     emit ContributeEvent (msg.sender,msg.value);
 }
 
 function getBalance() public view returns(uint){
     return address(this).balance;
 }
 
 function refund() public {
     require(raisedAmount<goal);
     require(now>deadline);
     require(contributor[msg.sender]>0); //verify the requester is part of contribution
     address rec=msg.sender;
     uint value=contributor[msg.sender];
     rec.transfer(value);
     contributor[msg.sender]=0; //make contributor balance as zero, so that he can't request once again.
 }
 
 function createRequest(string _desc, address _rec,uint _value) public{
     Request memory newRequest =Request({
         desc:_desc,
         rec:_rec,
         value:_value,
         completed:false,
         noOfVoters:0
     });
     requests.push(newRequest);
     emit CreateRequestEvent (_desc,_rec,_value);
 }
 
 function voteRequest(uint index) public {
     Request storage thisRequest=requests[index];
     require(contributor[msg.sender]>0);
     require(thisRequest.voters[msg.sender]==false);
     thisRequest.voters[msg.sender]=true;
     thisRequest.noOfVoters++;
 }
 
 modifier onlyAdmin(){
     require(msg.sender==admin);
     _;
 }
  function payToNeedy(uint index) public onlyAdmin {
           Request storage thisRequest=requests[index];
           require(thisRequest.completed==false);
      require(thisRequest.noOfVoters>noOfContributors/2);
      thisRequest.completed=true;
      thisRequest.rec.transfer(thisRequest.value);
      emit PaymentEvent(thisRequest.rec,thisRequest.value);
  }  
}