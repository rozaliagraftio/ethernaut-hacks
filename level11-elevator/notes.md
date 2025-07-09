# **Level 11 — Elevator**

## 🎯 Goal  
Make the `top variable` in the "Elevator" contract become true.

## 💥 Vulnerability  
The Elevator contract blindly trusts the `msg.sender` to implement the "Building" interface.
It calls `isLastFloor()` twice, expecting consistent behavior.
However, in Solidity, we can create a contract that changes its answer between calls, e.g. by using an additional variable `counter` (see the code).
This way, the first call returns false to pass the if check and the second returns true, setting **top = true**.

The part of the vulnerable code:
```solidity 
// Solidity code 
if (!building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
        }
```

## 🛠 ️Solution (via browser console +  Remix IDE)
The following steps were executed:
```js
// 1. Check temporary floor - 0 
(await contract.floor()).toString()
// 2. Check temporary value of the top variable - false 
(await contract.top()).toString()
// 3. Deploying ElevatorAttack.sol and call attack() function
// (Full attack logic is in ElevatorAttack.sol)
// 4. Recheck the top value - true
(await contract.top()).toString()
```

## 🧙 Outcome
This level violates a fundamental security principle: **never trust external code without restrictions or validation**.
The Elevator contract assumes that the `isLastFloor` function of the "Building"  contract will return the same result for the same input, but this assumption is the core vulnerability we exploited to hack the level.
Even if the function were marked with `view` or `pure`, it would still be possible to solve the level — not by modifying storage variables, but by leveraging environmental behavior, such as `gasleft()`.
