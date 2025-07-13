# **Level 14 — GatekeeperTwo**

## 🎯 Goal  
Bypass the gatekeeper TWO (3 gates again as in the gatekeeper ONE) and register as an entrant to complete this level.

## 💥 Vulnerability and Attack Strategy
**The vulnerable part of the code: (3 gates)**
```solidity 
// Solidity code 
modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        uint256 x;
        assembly {
            x := extcodesize(caller())
        }
        require(x == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max);
        _;
    }
```
1) **Gate One:** This gate is identical to "GatekeeperOne": the msg.sender must not be equal to tx.origin. That's why the `enter()` function must be called from attacking contract.

2) **Gate Two:** This gate uses a low-level EVM instruction `extcodesize(address)` which returns the size of the code at a given address.
How it behaves: **extcodesize(EOA)**  returns 0 (because EOAs have no code); **extcodesize(contract_address)**  returns the size of that contract’s bytecode.
To pass the first gate, we must call enter() from within another contract. So if we call `extcodesize(address(this))` **from within the constructor** - the code size will still be zero, because the contract is not yet fully deployed.
**This is a well-known hack**: _the contract address is already known inside the constructor, but its code has not been stored yet — so the code size is still 0_.

3) **Gate Three:**.
Let’s break this gate down step by step:
```solidity 
require(
  uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) 
  == type(uint64).max
);
```
- `type(uint64).max` returns the maximum value for a 64-bit unsigned integer: 0xffffffffffffffff (64 ones in binary)
- `^` is the **bitwise XOR operator**: to satisfy the condition, _gateKey must contain all bits flipped relative to the hash value:
`uint64 gateKey = ~uint64(bytes8(keccak256(abi.encodePacked(address(this)))));`

This is done inside the constructor, and then we call the enter() function using .call{...} with the calculated gateKey.
Upon success, we become the entrant.

## 🛠 ️Solution (via browser console +  Remix IDE)
The following steps were executed:
```js
// 1. Check the current entrant - not me
(await contract.entrant()).toString()
// 2. Deploy the GatekeeperTwoAttack.sol contract
// (Full attack logic is in GatekeeperOneAttack.sol)
// 3. Recheck the entrant — should now be my EOA (MetaMask address)
(await contract.entrant()).toString()
```

## 🧙 Outcome
With the correct _gateKey and by executing all actions within the constructor of the attacking contract (**to exploit the fact that extcodesize returns 0 during deployment**), we successfully bypass all three gates and become the entrant.

