pragma solidity ^0.4.24;

contract FundManagement{
    address public owner;
    uint public amount;
    constructor() public{
        owner=msg.sender;
    }
    
    function getBalance () public view returns (uint){
        return address(this).balance;
    }
    
    // fallback function
    function () payable public{
        amount+=msg.value;
    }
    
    function transferFund(address rec,uint value) public {
        rec.transfer(value);
    }
}