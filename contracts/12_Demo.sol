// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./12_Interfaces.sol";
import "./Extensions.sol";

contract Demo {
    ILogger logger;

    constructor(address _logger) {
        logger = ILogger(_logger);
    }

    receive() external payable {
        logger.log(msg.sender, msg.value);    
    }

    function payment(address _from, uint _number) public view returns(uint) {
        return logger.getLog(_from, _number);
    }
}

contract LibDemo {
    using StringExtension for string;
    using UintArrayExtension for uint[];
    
    function runnerStr(string memory str1, string memory str2) public pure returns(bool) {
        return str1.equals(str2);
    }

    function runnerUintArray(uint[] memory array, uint value) public pure returns(bool) {
        return array.contains(value);
    }
}