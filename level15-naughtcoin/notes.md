# **Level 15 — Naught Coin**

## 🎯 Goal  
To drain the token balance from my own address.

## 💥 Vulnerability and Attack Strategy
The NaughtCoin contract inherits from the base ERC-20 contract written by OpenZeppelin. 
In this child contract only 1 of the 6 standard ERC-20 functions `transfer` is overridden with the `lockTokens modifier`, which prevents transferring tokens via this method (unless you're willing to wait 10 years 😄). 
However, according to the **ERC-20 standard**, tokens can also be moved using another method: by first calling `approve(address, amount)` to allow another address to spend tokens and then calling `transferFrom(my_address, new_address, amount)`. 
**For `transferFrom` to succeed - msg.sender** must be the address that has the approval to move tokens from my_address  and **new_address** can be any recipient. 

The part of the vulnerable code:
```solidity
function transfer(address _to, uint256 _value) public override lockTokens returns (bool) {
        super.transfer(_to, _value);
    }

    // Prevent the initial owner from transferring tokens until the timelock has passed
    modifier lockTokens() {
        if (msg.sender == player) {
            require(block.timestamp > timeLock);
            _;
        } else {
            _;
        }
    }
```

## 🛠 ️Solution (via browser console +  Remix IDE)
The following steps were executed:
```js
// 1. Check my current balance - 1000000000000000000000000
(await contract.balanceOf(player)).toString()
// 2. Deploy the NaughtCoinAttack.sol contract
// (Full attack logic is in NaughtCoinAttack.sol)
// 3. Recheck mu balance of NaughtCoin — 0
(await contract.balanceOf(player)).toString()
```

## 🧙 Outcome
By restricting token transfers only through the transfer function, the hacker still has the ability to withdraw tokens using other standard functions — in this case, the combination of **approve + transferFrom**. Level completed, player's balance drained.

