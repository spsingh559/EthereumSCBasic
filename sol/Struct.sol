pragma solidity ^0.4.24;

contract CarsContract{
    
    // define struct
    struct Car{
        string desc;
        uint value;
        uint built_year;
    }
    
    // instantiate struct
    Car public private_car;
    
    // constructor and initialise struct
    constructor(string _desc,uint _value,uint _built_year) public{
        private_car.desc=_desc;
        private_car.value=_value;
        private_car.built_year=_built_year;
        cars[msg.sender]=private_car;
        // not valid 
        // private_car ={
        //     desc:_desc,
        //     value:_value,
        //     built_year:_built_year
        // }
    }
    
    // mapping to store cars with address
    mapping (address => Car)  public cars;
    
    function modifyCar (string _desc,uint _value,uint _built_year) public {
        Car memory newCar= Car({
            desc:_desc,
            value:_value,
            built_year:_built_year
        });
        private_car=newCar;
    
        cars[msg.sender]=private_car;
    }
    
    
}