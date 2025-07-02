# **Level 04 — Telephone**

## 🎯 Goal  
To claim ownership of the contract.

## 💥 Vulnerability  
The contract uses `tx.origin` instead of `msg.sender` for authentication.
This makes it vulnerable to phishing-style attacks via intermediary contracts.

The part of the vulnerable code:
```solidity 
// Solidity code 
function changeOwner(address _owner) public {
        if (tx.origin != msg.sender) {
            owner = _owner;
        }
    }
```

## 🛠 ️Solution (via Remix IDE)
An attacker deploys the malicious contract and calls `attack()` externally.
Since the call originates from the user's wallet (EOA) but goes through the attack contract, the check passes.
(Full exploit logic is available in `TelephoneAttack.sol`).

## 🧙 Outcome
Ownership was successfully claimed by exploiting the improper use of tx.origin.
