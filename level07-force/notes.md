# **Level 07 - Force**

## 🎯 Goal  
To make the balance of the contract greater than zero.

## 💥 Vulnerability  
Even if a contract does not have a `receive()` or `fallback()` function - it can still receive Ether through the use of `selfdestruct` in another contract.
This bypasses all standard checks and forcibly transfers Ether to the target contract.

## 🛠 ️Solution (via browser console +  Remix IDE)
The following steps were executed:
```js
// 1. Check the current balance - 0
(await web3.eth.getBalance(my_instance_address)).toString()
// 2. Deploy ForceAttack.sol in Remix with a small amount of Ether, then call explode() to selfdestruct and send Ether to the target 
// (Full attack logic is in ForceAttack.sol)
// 3. Recheck the balance - 1000000000000 
(await web3.eth.getBalance(my_instance_address)).toString()
```

## 🧙 Outcome
By deploying a separate contract and invoking its selfdestruct, Ether was forcibly sent to the target contract, completing the level.
