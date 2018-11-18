pragma solidity ^0.4.24;

contract MappingContract{
    
    // get a owner or admin of contract.
    address public owner;
    
    // assignning address when contract is created.
    constructor() public{
        owner=msg.sender;
    }
    mapping (address => uint) public bids;
    
    
    // storing ether in particular address of sender in a contract.
    function bid() payable public {
        bids[msg.sender]=msg.value;
    }
}