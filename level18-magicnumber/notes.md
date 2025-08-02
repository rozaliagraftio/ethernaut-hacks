# **Level 18 — MagicNumber**

## 🎯 Goal  
To deploy an extremely small smart contract (≤10 bytes in blockchain storage) that returns the answer to `whatIsTheMeaningOfLife()` — specifically, the number 42 in 32-byte format.

## 💥 Theoretical background
If we write a typical contract in Remix like this:
```solidity 
contract MagicNumberAttack {
    function whatIsTheMeaningOfLife() public pure returns (uint256) {
        return 42;
    }
}
```
-- the resulting bytecode will take up tens of bytes.

To reduce the size, we need to manually craft and submit raw bytecode using EVM-level opcodes via inline assembly in Solidity.

There are **only 256 opcodes in EVM** — each is a 1-byte instruction.

**EVM is a low-level stack-based virtual machine**, like Assembly. All arguments for operations are pushed onto the stack (LIFO order).

Essential opcodes used in this task:

- `PUSH1` ---> Push 1 byte to stack (0x60)
- `PUSH10` ---> Push 10 bytes to stack (0x69)
- `MSTORE` ---> Write 32 bytes to memory (0x52)
- `RETURN` ---> Return data from memory (0xF3)

## 🛠 ️Solution steps
### 1) **Runtime code**
Let’s write the code that will be the contract’s code on the blockchain.

We want to return the number 42 from memory. To return it — we first need to store it in memory.

- `mstore(pos, value)` — store the value in memory from position pos to pos + 32 (not inclusive), 
- `return(pos, offset)` — return bytes from memory from position pos to pos + offset (not inclusive).

```assembly
PUSH1 0x2a    // push 42 onto the stack
PUSH1 0x00    // push 0 (memory offset) to the stack
MSTORE        // writes 32-bytes format of 42 to memory
PUSH1 0x20    // push 32 onto the stack (the size of return data)
PUSH1 0x00    // push 0 (memory pointer) to the stack
RETURN       // return 42 from the memory from 0 pointer
```

Final runtime bytecode: `60 2a 60 00 52 60 20 60 00 f3` (exactly 10 bytes).

### 2) **Creation code**
In order for the runtime-code to be deployed — it too must be placed onto the stack of the virtual machine, and then returned from there.

```assembly
PUSH10 <runtime-code>  // push 10-bytes runtime code
PUSH1 0x00              // push 0 (memory offset) to the stack (as usual)
MSTORE                  // store 10 bytes with padding 
PUSH1 0x0a              // push 10 - the lenght of the runtime-code onto the stack
PUSH1 0x16              // push offset onto the stack: byte position 22 in memory (padding!)
RETURN                 // return runtime-code from the memory from 22 pointer
```
This will properly deploy the minimal contract that returns 42.

### 3) **Deploying the contract** 

We write a contract in Remix — `Factory.sol`, which deploys our tiny contract to the blockchain.

To do this, we use the Solidity assembly function: `create(value, offset, size)`, where:
- **value** — how much Ether to send during deployment (in wei),
- **offset** — the offset in memory from where the bytecode starts (the offset appears because bytes is a dynamic data structure, and it is always preceded by its length in 32 bytes — an extra 32 bytes representing the length),
- **size** — the size in bytes of the bytecode

### 3) **Verifying the deployed contract**
After deploying the contract, we use the known address to call it via an interface:
```solidity 
interface IContract {
    function whatIsTheMeaningOfLife() external view returns (uint256);
}
```

Calling `whatIsTheMeaningOfLife()` should return the number 42, proving the contract works as intended.

## 🧙 Outcome
We’ve deployed a fully functional, minimal contract in just 10 bytes using raw EVM opcodes and Solidity inline assembly. This allowed us to successfully complete the level.




