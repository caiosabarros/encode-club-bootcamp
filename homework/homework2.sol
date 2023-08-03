pragma solidity ^0.8.13;

import "hardhat/console.sol";
/**
Write a function that will delete items (one at a time) from a dynamic array without leaving
gaps in the array. You should assume that the items to be deleted are chosen at random, and
try to do this in a gas efficient manner.
For example imagine your array has 12 items and you need to delete the items at indexes 8,
2 and 7.
The final array will then have items {0,1,3,4,5,6,9,10,11}

@author Caio Sá
*/

contract DeleteItemsInDinamicArray {

    uint[] dinamicNumberArray;

    constructor() {
    /*populate array to initiate the storage slots 
    on deployment, so that costs are upon the deployer,
    not the end-user
    */
    dinamicNumberArray.push();
    dinamicNumberArray.push(1);
    dinamicNumberArray.push(2); //to be deleted
    dinamicNumberArray.push(3);
    dinamicNumberArray.push(4);
    dinamicNumberArray.push(5);
    dinamicNumberArray.push(6);
    dinamicNumberArray.push(7); //to be deleted
    dinamicNumberArray.push(8); //to be deleted
    dinamicNumberArray.push(9);
    dinamicNumberArray.push(10);
    dinamicNumberArray.push(11);
    }

    function returnArray() external view returns(uint[] memory) {
        return dinamicNumberArray;
    }
    
    // The only drawback of this function is that it deletes the element
    // in the newly created array, not in the original array.
    function deleteRandomElement(uint _index) external {
        uint256 arrayLength = dinamicNumberArray.length; //12
        console.log("arrayLength: ", arrayLength);
        require(arrayLength >= _index, "out of bonds");
        // strategy: shifts elements onto the left and pop last
        uint256 elementToDelete = dinamicNumberArray[_index];
        console.log("elementToDelete: ", elementToDelete);
        for(uint256 i = _index; i < arrayLength;) { 
            console.log("i: ", i);
            if(i + 1 == arrayLength) dinamicNumberArray[arrayLength - 1] = elementToDelete;
            else {
                dinamicNumberArray[i] = dinamicNumberArray[i + 1];
            }
            unchecked {
                ++i;
            }
        }
        dinamicNumberArray.pop();
    }
    
    //function for debugging
    function returnByIndex(uint256 _index) external view returns(uint256) {
        return dinamicNumberArray[_index];
    }
} 


