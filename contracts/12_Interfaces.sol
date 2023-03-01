// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Logger {
    mapping(address => uint[]) payments;

    function log(address _from, uint _amount) public {
        require(_from != address(0), "address is empty");
        payments[_from].push(_amount);
    }

    function getLog(address _from, uint _index) public view returns(uint) {
        require(_from != address(0), "address is empty");
        require(_index >= 0, "index less than zero");
        return payments[_from][_index];
    }
}

interface ILogger {
    function log(address _from, uint _amount) external;
    function getLog(address _from, uint _index) external view returns(uint);
}