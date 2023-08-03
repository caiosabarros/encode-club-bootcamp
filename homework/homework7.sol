pragma solidity ^0.8.4;

contract Scope {
  
  function query(uint _amount, address _receiver, function (address to, uint amount) external returns(bool) transfer) public {
      require(transfer(_receiver, _amount), "unsuccessful transfer");
  }
}

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

pragma solidity ^0.8.4;
/*
The data parameter is bytes encoded representing the following
Function selector
Target address
Amount (uint256)
Complete the function body as follows
The function should revert if the function is not an ERC20 transfer function.
Otherwise extract the address and amount from the data variable and emit an event with those
details
event transferOccurred(address,uint256);
*/

contract Call {
    event transferOccurred(address,uint256);

    function checkCall(bytes calldata data) external{
    (bytes4 selector, address to, uint amount) = abi.decode(data, (bytes4, address, uint256));
    //abi.decode(data, (uint, uint[2], bytes))
    require(selector == IERC20.transfer.selector, "!transfer");
    emit transferOccurred(to, amount);
    }
}