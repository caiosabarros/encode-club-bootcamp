
contract VulnerableXToken {
    // ..

    // Pay some tokens and earn some shares.
    function enter(uint256 _amount) public {
        uint256 totalToken = token.balanceOf(address(this));
        uint256 totalShares = totalSupply();
        if (totalShares == 0 || totalToken == 0) {
            _mint(msg.sender, _amount);
        } else {
            uint256 what = _amount.mul(totalShares).div(totalToken);
            _mint(msg.sender, what);
        }
        token.transferFrom(msg.sender, address(this), _amount);
    }

    // Claim back your tokens.
    function leave(uint256 _share) public {
        uint256 totalShares = totalSupply();
        uint256 what = _share.mul(token.balanceOf(address(this))).div(totalShares);
        _burn(msg.sender, _share);
        token.transfer(msg.sender, what);
    }
    
    // ..
}