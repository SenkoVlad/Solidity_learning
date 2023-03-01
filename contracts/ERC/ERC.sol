// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../interfaces/IERC20.sol";

abstract contract ERC20 is IERC20 {
    uint _totalTokens = 0;
    address owner;
    mapping (address => uint) balances;
    mapping (address => mapping(address => uint)) allowances;
    string _name;
    string _symbol;
    uint _decimals;
    uint _totalSupply;

    function name() external view override returns(string memory) {
        return _name;
    }

    function symbol() external view override returns(string memory) {
        return _symbol;
    }

    function decimals() external view override returns(uint) {
        return _decimals;
    }

    function totalSupply() external view override returns (uint) {
        return _totalSupply;
    }

    function totalTokens() external view returns(uint) {
        return _totalTokens;
    }

    modifier enoughTokens(address _from, uint _amount) {
        require(balanceOf(_from) >= _amount, "balance is not enough tokens");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "is not an owner");
        _;
    }

    constructor(string memory name_, string memory symbol_, uint initialSupply, address shop) {
        _name = name_;
        _symbol = symbol_;
        owner = msg.sender;
        mint(initialSupply, shop);
    }

    function balanceOf(address account) public view override returns(uint) {
        return balances[account];
    }

    function transfer(address to, uint amount) external override enoughTokens(msg.sender, amount) {
        _beforeTokenTransfer(msg.sender, to, amount);
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }

    function mint(uint amount, address shop) public onlyOwner {
        _beforeTokenTransfer(address(0), shop, amount);
        balances[shop] += amount;
        _totalTokens += amount;
        emit Transfer(address(0), shop, amount);
    }

    function burn(address _from, uint amount) public onlyOwner {
        _beforeTokenTransfer(_from, address(0), amount);
        balances[_from] -= amount;
        _totalTokens -= amount;
    }

    function allowance(address owner_, address spender) public view override returns(uint) {
        return allowances[owner_][spender];
    }

    function approve(address spender, uint amount) public override {
        _approve(msg.sender, spender, amount);
    }

    function _approve(address owner_, address spender, uint amount) internal virtual {
        allowances[owner_][spender] = amount;
        emit Approve(owner_, spender, amount);
    }

    function transferFrom(address sender, address recipient, uint amount) external override enoughTokens(sender, amount) {
        _beforeTokenTransfer(sender, recipient, amount);
        require(allowances[sender][recipient] >= amount, "check allowance!");
        allowances[sender][recipient] -= amount;
        balances[recipient] += amount;
        balances[sender] -= amount;
        emit Transfer(sender, recipient, amount);
    }

    function _beforeTokenTransfer(
        address from,
        address to, 
        uint amount) internal virtual { }
}