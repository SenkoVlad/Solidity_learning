// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


library StringExtension {
    function equals(string memory str1, string memory str2) internal  pure returns(bool) {
        return keccak256(abi.encode(str1)) == keccak256(abi.encode(str2));
    }
}

library UintArrayExtension { 
    function contains(uint[] memory array, uint value) internal pure returns(bool) {
        for (uint i=  0; i < array.length; i++) {
            if(array[i] == value) {
                return true;
            }
        }
        return false;
    }
}

