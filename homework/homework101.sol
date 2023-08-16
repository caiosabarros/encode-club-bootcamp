pragma solidity ^0.8.0;

contract Hello {

    function hello(uint numerator, uint denominator) external pure returns(uint result) {
        result = numerator / denominator; // execution gas cost: 934
    }

    function cool(uint numerator, uint denominator) external pure returns(uint result) {
        assembly {
            result := div(numerator, denominator) //execution gas cost: 783
        }
    }
}



