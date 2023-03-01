// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../interfaces/IERC20.sol";
import "./MCSToken.sol";

contract MShop {
    IERC20 public token;
    address payable public owner;
    event Bought(uint _amount, address indexed _buyer);
    event Sold(uint _amount, address indexed _seller);

    constructor() {
        token = new MCSToken(address(this));
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "is not an owner");
        _;
    }

    function sell(uint _amountToSell) external {
        require(_amountToSell > 0 &&
                token.balanceOf(msg.sender) >= _amountToSell,
                "The amount to sell is greater than balance or is not greater than zero");
        uint allowance = token.allowance(msg.sender, address(this));
        require(allowance >= _amountToSell, "allowance is less than amount to sell");
    
        token.transferFrom(msg.sender, address(this), _amountToSell);
        payable(msg.sender).transfer(_amountToSell);
        emit Sold(_amountToSell, msg.sender);
    }

    function tokenBalance() public view returns(uint) {
        return token.balanceOf(address(this));
    }

    receive() external payable {
        uint tokensToBuy = msg.value;
        require(tokensToBuy > 0, "tokensToBuy should be greater than 0");
        require(tokenBalance() >= tokensToBuy, "currentBalance should be equal or greater than tokensToBuy");

        token.transfer(msg.sender, tokensToBuy);
        emit Bought(tokensToBuy, msg.sender);
    }
}