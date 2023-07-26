function harvest() public {
  withdrawTokenA(); 
  uint256 reward = TokenA.balanceOf(address(this));
  unirouter.swapExactTokensForTokens(reward, 0, pathTokenAB, this, now.add(1800));
  depositTokenB();
}

/*
    Here we have an internal function that withdraws token A from somewhere - probably a vault.

    The reward is set to be the contract's token A balance

    Then the swap function swaps token A for getting token B.

    After the tokens B are gotten, they're depositted to the vault.

    So, to summarize: harvest()ing is the action of swapping the contract's balance for another token and sending the other token to somewhere.
*/