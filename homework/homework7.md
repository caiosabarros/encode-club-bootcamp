1. The parameter X represents a function.
Complete the function signature so that X is a standard ERC20 transfer function (other than the
visibility)
The query function should revert if the ERC20 function returns false
```
function query(uint _amount, address _receiver, X) public {
...
}
```

2. The following function checks function details passed in the data parameter.
The data parameter is bytes encoded representing the following
Function selector
Target address
Amount (uint256)
Complete the function body as follows
Otherwise extract the address and amount from the data variable and emit an event with those
details
function checkCall(bytes calldata data) external{
}
event transferOccurred(address,uint256)