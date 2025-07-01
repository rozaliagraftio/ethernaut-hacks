# **Level 03 — CoinFlip**

## 🎯 Goal  
To build up the winning streak by guessing the outcome of a coin flip 10 times in a row. 

## 💥 Vulnerability  
The contract relies on a **predictable source of randomness**: `blockhash(block.number - 1)`.
However, in Ethereum, this value is publicly accessible and not truly random — it’s fully deterministic.

The string of the vulnerable code:
```solidity 
// Solidity code 
uint256 blockValue = uint256(blockhash(block.number - 1));
```

## 🛠 ️Solution (via Remix IDE)
Since anyone can calculate blockhash(block.number - 1) off-chain, an attacker can accurately predict the outcome before calling the contract.
Attacking contract `CoinFlipAttack.sol` is deployed and its attack() function is invoked 10 consecutive times to exploit the vulnerability.

## 🧙 Outcome
By repeating the attack 10 times, the contract accepted the player as having won 10 flips in a row — level completed.
