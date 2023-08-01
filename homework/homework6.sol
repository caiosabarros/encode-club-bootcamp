
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