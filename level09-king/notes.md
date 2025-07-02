# **Level 09 — King**

## 🎯 Goal  
Become the king of the contract (i.e., update king to your address) and block anyone else from claiming the throne.

## 💥 Vulnerability  
The contract uses `transfer()` to send Ether back to the previous king.
However, **transfer() automatically reverts if the recipient is a contract without a receive() or fallback() function**.

**This creates a vulnerability:**
An attacker can deploy a contract without any Ether-receiving function, claim the throne and then prevent further transfers, locking the king’s position permanently.

(⚠️ This is one reason why using `transfer()` is now discouraged. Modern best practices favor `call{value: ...}("")` with proper error handling).

**The string of the vulnerable code:**
```solidity 
// Solidity code 
payable(king).transfer(msg.value);
```

## 🛠 ️Solution (via browser console +  Remix IDE)
The following steps were executed:
```js
// 1. Check the current prize - 1000000000000000
(await contract.prize()).toString()
// 2. Check the current king - some_address
(await contract._king()).toString()
// 3. Deploying KingAttack.sol and call attack() function
// (Full attack logic is in KingAttack.sol)
// 4. Recheck the king - my_contract_address
(await contract._king()).toString()
```

## 🧙 Outcome
The malicious contract successfully claimed the throne and permanently blocked any further changes of kingship. Level completed.
