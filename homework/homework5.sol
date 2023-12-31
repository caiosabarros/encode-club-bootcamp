// SPDX-License-Identifier: MIT
pragma solidity 0.8.6;

//EXERCISE 1 FROM 6:
contract Intro {
    //returns 420!
    function intro() public pure returns (uint16) {
        uint256 mol = 420;

        // Yul assembly magic happens within assembly{} section
        assembly {
            // stack variables are instantiated with
            // let variable_name := VALßUE
            // instantiate a stack variable that holds the value of mol
            let value := mol
            // To return it needs to be stored in memory
            let free := mload(0x40)
            mstore(free, value)
            // with command mstore(MEMORY_LOCATION, STACK_VARIABLE)
            // to return you need to specify address and the size from the starting point
            return(free, 0x20)
        }
    }
}

//EXERCISE 2 FROM 6:
contract Add {
    function addAssembly(uint256 x, uint256 y) public pure returns (uint256) {
        // Intermediate variables can't communicate between  assembly blocks
        // But they can be written to memory in one block
        // and retrieved in another.
        // Fix this code using memory to store the result between the blocks
        // and return the result from the second block
        assembly {
            let result := add(x, y)
            mstore(mload(0x40),result)
        }

        assembly {
            return(mload(0x40),0x20)
        }
    }
}

//EXERCISE 3 FROM 6:
contract SubOverflow {
    // Modify this function so that on overflow it returns the value 0
    // otherwise it should return x - y
    function subtract(uint256 x, uint256 y) public pure returns (uint256) {
        // Write assembly code that handles overflows
        assembly {
            let res := 0
            let free := mload(0x40)
            mstore(free,res)
            //as safemath, it doesn't over/underflow if x - y < x 
            if gt(sub(x,y),x) {mstore(free,0)} 
            if lt(sub(x,y),x) {mstore(free,sub(x,y))}
            if eq(sub(x,y),x) {mstore(free,0)}
            return(free, 0x20)
        }
    }
}

//EXERCISE 4 FROM 6:
contract Scope {
    uint256 public count = 10;

    function increment(uint256 num) public {
        //EXERCISE: Modify state of the count variable from within
        //EXERCISE: the assembly segment
        assembly {
          //ME: count uses the first storage slot
          sstore(0,num)
          
        }
    }
}


contract Deploy1{

    uint256 value1;

    constructor(){
        value1 = 17;
    }

    function read() view public returns (uint256 result){
        return value1;
    }
}


"object": "608060405234801561001057600080fd5b50601160008190555060b6806100276000396000f
3fe6080604052348015600f57600080fd5b506004361060285760003560e01c806357d
e26a414602d575b600080fd5b60336047565b604051603e9190605d565b60405180910
390f35b60008054905090565b6057816076565b82525050565b6000602082019050607
060008301846050565b92915050565b600081905091905056fea264697066735822122
0872b5d4b9f200afddd5ed3c424f6b3b995bf467e212ec4c313f65365aeadf8e964736
f6c63430008060033",     
"opcodes": "PUSH1 0x80 PUSH1 0x40 MSTORE
CALLVALUE DUP1 ISZERO PUSH2 0x10 JUMPI PUSH1 0x0 DUP1 REVERT JUMPDEST
POP PUSH1 0x11 PUSH1 0x0 DUP2 SWAP1 SSTORE POP PUSH1 0xB6 DUP1 PUSH2
0x27 PUSH1 0x0 CODECOPY PUSH1 0x0 RETURN INVALID PUSH1 0x80 PUSH1 0x40
MSTORE CALLVALUE DUP1 ISZERO PUSH1 0xF JUMPI PUSH1 0x0 DUP1 REVERT
JUMPDEST POP PUSH1 0x4 CALLDATASIZE LT PUSH1 0x28 JUMPI PUSH1 0x0
CALLDATALOAD PUSH1 0xE0 SHR DUP1 PUSH4 0x57DE26A4 EQ PUSH1 0x2D JUMPI
JUMPDEST PUSH1 0x0 DUP1 REVERT JUMPDEST PUSH1 0x33 PUSH1 0x47 JUMP
JUMPDEST PUSH1 0x40 MLOAD PUSH1 0x3E SWAP2 SWAP1 PUSH1 0x5D JUMP
JUMPDEST PUSH1 0x40 MLOAD DUP1 SWAP2 SUB SWAP1 RETURN JUMPDEST PUSH1
0x0 DUP1 SLOAD SWAP1 POP SWAP1 JUMP JUMPDEST PUSH1 0x57 DUP2 PUSH1
0x76 JUMP JUMPDEST DUP3 MSTORE POP POP JUMP JUMPDEST PUSH1 0x0 PUSH1
0x20 DUP3 ADD SWAP1 POP PUSH1 0x70 PUSH1 0x0 DUP4 ADD DUP5 PUSH1 0x50
JUMP JUMPDEST SWAP3 SWAP2 POP POP JUMP JUMPDEST PUSH1 0x0 DUP2 SWAP1
POP SWAP2 SWAP1 POP JUMP INVALID LOG2 PUSH5 0x6970667358 0x22 SLT
KECCAK256 DUP8 0x2B 0x5D 0x4B SWAP16 KECCAK256 EXP REVERT 0xDD 0x5E
0xD3 0xC4 0x24 0xF6 0xB3 0xB9 SWAP6 0xBF CHAINID PUSH31
0x212EC4C313F65365AEADF8E964736F6C634300080600330000000000000000 "





