pragma solidity ^0.4.24;

contract BetContract{
    address[] public players;
    address public manager;
    
    constructor() public{
    manager=msg.sender;
}

// this function will get executed when any address send ether to this contract
function () payable public{
    require (msg.value>=0.001 ether);
    players.push(msg.sender); //for adding all players in contract
}

function getBalance() public view returns (uint){
    require (msg.sender==manager); //only manager can view the balance
    return address(this).balance;  //for checking balance
}

function random() public view returns (uint256){
    return uint256(keccak256(block.difficulty,block.timestamp,players.length));
}

function winner() public {
    require(msg.sender==manager);
    uint rand=random();
    players[rand%players.length].transfer(address(this).balance);
    players = new address[](0); // reset the player list
    
}
    
}