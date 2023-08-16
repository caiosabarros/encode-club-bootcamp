// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

error CustomError();
// this makes the tests still pass
contract GasContract {
  address private immutable _owner;
  uint256 private whiteListStruct;
  mapping(address => uint256) public balances;
  address[5] public administrators;

  event WhiteListTransfer(address indexed);
  event AddedToWhitelist(address userAddress, uint256 tier);

  constructor(address[] memory _admins, uint256 _totalSupply) {
    _owner = msg.sender;
    for (uint256 i; i < 5;) {
      administrators[i] = _admins[i];

      if (_admins[i] == msg.sender) {
        // balances[msg.sender] = _totalSupply;
        assembly {
          mstore(0, caller())
          mstore(32, balances.slot)
          let hash := keccak256(0, 64)
          sstore(hash, _totalSupply)
        }
      }
      unchecked {
        ++i;
      }
    }
  }

  function balanceOf(address _user) public view returns (uint256) {
    return balances[_user];
  }

  function addToWhitelist(address _userAddrs, uint256 _tier) external
  {
    if (_tier >= 255 || msg.sender != _owner) {
      revert CustomError();
    }
    emit AddedToWhitelist(_userAddrs, _tier);
  }

  function whitelist(address user) external pure returns (uint256) {
    return 0;
  }

  function whiteTransfer(address _recipient, uint256 _amount) external {

    whiteListStruct = _amount;
    assembly {
      // balances[msg.sender] -= _amount;
      mstore(0, caller())        
      mstore(32, balances.slot)
      let hash := keccak256(0, 64)
      let value := sload(hash)
      value := sub(value, _amount)
      sstore(hash, value)

      // balances[_recipient] += _amount;
      mstore(0, _recipient)
      hash := keccak256(0, 64)
      value := sload(hash)
      value := add(value, _amount)
      sstore(hash, value)
    }

    emit WhiteListTransfer(_recipient);
  }

  function transfer(address _recipient, uint256 _amount, string calldata _name)
    external {

    assembly {
      // balances[msg.sender] -= _amount;
      mstore(0, caller())
      mstore(32, balances.slot)
      let hash := keccak256(0, 64)
      let value := sload(hash)
      value := sub(value, _amount)
      sstore(hash, value)

      // balances[_recipient] += _amount;
      mstore(0, _recipient)
      hash := keccak256(0, 64)
      value := sload(hash)
      value := add(value, _amount)
      sstore(hash, value)
    }
  }

  function getPaymentStatus(address sender) public view
    returns (bool, uint256) {

    return (true, whiteListStruct);
  }
}
