pragma solidity ^0.4.24;

contract A{
    address public owner;
    constructor(address _eoa) public{
        owner=_eoa;
    }
}


contract Parent{
    address public parentOwner;
    address[] public deployedAddress;
    constructor() public{
        parentOwner=msg.sender;
    }
    
    // modifier onlyParentOwner(){
    //     require(msg.sender==parentOwner);
    //     _;
    // }
    
    function Deploy() public {
    address newA_Address= new A(parentOwner);
    deployedAddress.push(newA_Address);
    }
}
