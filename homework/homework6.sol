
pragma solidity ^0.8.0;

/*
Create a contract with a function in Yul that returns the msg.value sent to it. 
*/
contract Encode {
  function returnETHSent() payable external returns(uint value)   {
    assembly {
         value:= callvalue()
    }
  }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.6;

contract Sum {
    //4. Write some Yul to:
    //1.Add 0x07 to 0x08
    //2.store the result at the next free memory location
    //3.(optional) write this again in opcodes

    function sum() public pure returns (bytes memory sum) {
        assembly {
            // Calculate the sum of 0x07 and 0x08
            sum := add(0x07, 0x08)

            // Get the size of the result (32 bytes for uint256)
            let size := 0x20

            // Allocate memory for the result
            let result := mload(0x40)
            mstore(result, sum)

            // Update the free memory pointer location
            mstore(0x40, add(result, size))
        }
        /*
        OPCODES:
        STACK ---> PUSH1 0x40 = 0x40 
        STACK ---> MLOAD / PUSH1 0x40 = LOCATION  
        PUSH1 0X07 --> 0X07 LOCATION
        PUSH1 0X08 --> 0X08 0X07 LOCATION
        ADD --> (0X08+0X07) LOCATION
        MSTORE --> ------
        */
    }
}
