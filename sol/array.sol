pragma solidity ^0.4.24;

contract simpleContract{
    
    uint[] public age ;
    
    
    function setAge(uint _age) public{
        age.push(_age);
    }
    
    // function where age can't be modified
    function getAge () public  view returns (uint[]){
        return age;
    }
    
    function delAge(uint index) public returns (bool) {
        for(uint i=index; i<age.length-1;i++){
            age[i]=age[i+1];
        }
        age.length--;
        return true;
    }
    
    // function w/o view, which can modify age, so on each return age will be 10 more.
    // function getAge () public  returns (int){
    //     return age=age+10;
    // }
}