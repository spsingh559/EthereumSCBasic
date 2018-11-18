pragma solidity ^0.4.24;

contract AccessModifier{
    
    // Private key example
    
    int x=10;
    uint public y=100;
    uint internal a=1000;
    // you cant have external variable;
    // uint external b=10000;
    
    
    // to access this need to make getter function
    function getX() view public returns (int){
        return x;
    }
    
    function getY() view public returns(uint){
        return y;
    }
    
    // can be visible insidde class or outside class if declared in publicj function
    function getA() view public returns(uint){
        return a;
    }
    
    // can't access in other class  except derived'
    function getAInternal() view internal returns(uint){
        return a;
    }
    
    function getExternal() view external returns(uint){
        return y;   
    }
}

// another contract
contract PublicAccess{
    AccessModifier accessModd = new AccessModifier();
    uint public z=accessModd.getY();
    uint public publicA=accessModd.getA();
    // not visible in outside class
    // uint public internalA=accessModd.getAInternal();
    
    uint public externalY=accessModd.getExternal();
}

// derive contract

contract derivedContract is AccessModifier{
    uint public internalA=getAInternal();
    uint public directInternal=a;
    // can't access directly like this to any external function'
    // uint public externalY=getExternal();
    
    // create instance of contract
    AccessModifier am=new AccessModifier();
    uint public externalY = am.getExternal();
}