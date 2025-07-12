# **Level 13 — GatekeeperOne**

## 🎯 Goal  
Bypass the gatekeeper and register as an entrant to complete this level.

## 💥 Vulnerability and Attack Strategy
**The part of the vulnerable code: (3 gates)**
```solidity 
// Solidity code 
modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        require(gasleft() % 8191 == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
        require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
        require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
        _;
    }
```
1) **Gate One is relatively easy to bypass.** By calling the enter function from a separate attacking contract, we ensure that msg.sender is our contract and tx.origin is our EOA (e.g., MetaMask address) — which satisfies the first gate's condition (**msg.sender != tx.origin**).

2) **Gate Two is more tricky.** It requires **gasleft() % 8191 == 0** at the moment the gate is checked.
Since the exact gas left at that point is hard to predict (due to variable gas consumption up to the check) - the most effective solution is to perform a **brute-force loop**. We try multiple values of gas (**i + 8191 * 10**) and send the call until we find the one that passes.

3) **Gate Three is more like a puzzle based on tx.origin**.
We reverse-engineer the _gateKey to satisfy all three conditions:

    - **uint32(uint64(_gateKey)) == uint16(uint160(tx.origin))**
    → We take the last 2 bytes of our address (e.g., 0xfd48) and ensure they match the last 4 bytes of _gateKey (e.g., 0x...00.00.fd.48).

    - **uint32(uint64(_gateKey)) != uint64(_gateKey)**
    → The full uint64 key must be different from its lower 32-bit version — so we set some non-zero upper bytes (e.g., 0x00.01.00.00.00.00.fd.48 - totally 8 bytes).

    - **uint32(uint64(_gateKey)) == uint16(tx.origin)**
    → Effectively already covered by condition #1.

Putting it all together, the valid _gateKey could look like:
**0x00.01.00.00.00.00.fd.48**

## 🛠 ️Solution (via browser console +  Remix IDE)
The following steps were executed:
```js
// 1. Check the current entrant - not me
(await contract.entrant()).toString()
// 2. Deploy the GatekeeperOneAttack.sol contract and call its attack() function
// (Full attack logic is in GatekeeperOneAttack.sol)
// 3. Recheck the entrant — should now be my EOA (MetaMask address)
(await contract.entrant()).toString()
```

## 🧙 Outcome
With the correct _gateKey and the correct gas value found via brute-force, we successfully bypass all three gates via attacking contract and become the entrant.


