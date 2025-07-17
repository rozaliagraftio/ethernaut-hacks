# **Level 16 — Preservation**

## 🎯 Goal  
To claim the ownership of the contract. 

## 💥 Vulnerability and Attack Strategy
The contract uses the low-level `delegatecall` function, **which executes the code of an external contract in the context of the calling contract**. This is dangerous because it modifies the storage of the caller and careless use can lead to critical vulnerabilities.

To exploit this, we only need the setFirstTime function in Preservation Contract.

1) Since delegatecall follows the storage layout strictly - it modifies slot 0 of the caller (i.e. timeZone1Library) when calling the external setTime function. So the first step is to replace the library address with the address of our malicious contract. Despite the type mismatch between address and uint256, this works via casting: `uint256(uint160(address))`.

2) After replacing the timeZone1Library with our contract, we call setFirstTime again. Now the delegatecall executes our version of setTime, which modifies slot 2 (where owner is stored). This allows us to hijack ownership of the contract.
    
The part of the vulnerable code:
```solidity
// Simple library contract to set the time
contract LibraryContract {
    // stores a timestamp
    uint256 storedTime;

    function setTime(uint256 _time) public {
        storedTime = _time;
    }
}
```

## 🛠 ️Solution (via browser console +  Remix IDE)
The following steps were executed:
```js
// 1. Check the current onership - not me 
(await contract.owner()).toString()
// 2. Deploy the PreservationAttack.sol contract
// (Full attack logic is in PreservationAttack.sol)
// 3. Recheck the  ownership - my MetaMask address
(await contract.owner()).toString()
```

## 🧙 Outcome
Ownership of the contract was successfully taken over. In the future, it's important to understand that **delegatecall can replace the intended logic with potentially malicious one**. Therefore, it's recommended to use `library` contracts instead of external logic contracts, as libraries do not have access to storage and cannot modify the state of the calling contract.

