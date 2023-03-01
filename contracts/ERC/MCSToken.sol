// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../interfaces/IERC20.sol";
import "./ERC.sol";

contract MCSToken is ERC20 {
    constructor(address shop) ERC20("MCSToken", "MST", 20, shop) {}
}