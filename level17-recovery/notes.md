# **Level 17 — Recovery**

## 🎯 Goal  
Recover the address of a lost contract holding 0.001 ETH and destroy it (= withdraw all the funds to my own address).

## 💥 Vulnerability
Ethereum contract addresses are not random — they are deterministic and calculated using a hash function over two parameters, serialized via RLP encoding: `keccak256(rlp.encode([creator_address, nonce]))[12:]`, where

- **creator_address** is the address that created the contract
- **nonce** is the number of contracts that address has previously deployed

The keccak256 hash returns 32 bytes, but Ethereum addresses are only 20 bytes long, so we take the last 20 bytes ([12:]).

The part of the vulnerable code:
```solidity 
function destroy(address payable _to) public {
        selfdestruct(_to);
    }
```

## 🛠 ️Solution ( Remix IDE + Node.js)
1) Calculate the lost contract address using a small JS script, because: 1. Ethereum console lacks RLP encoding 2. Remix IDE doesn't support RLP either
(full logic is in Recovery.js)

2) Copy the source code of the SimpleToken contract into Remix IDE. Then compile the contract, but do not deploy it. Use the `At Address` tab in Remix to interact with the contract at the computed address. Call the `destroy` function and pass in our EOA address —> the ETH is recovered to our wallet.

## 🧙 Outcome
The contract was successfully destroyed (verified on **Etherscan** (Sepolia TestNet) — the balance of 0.001 ETH became zero after calling destroy function.

The ability to precompute contract addresses allows for an **ultra-secret way to store ETH** without wallets, exchanges or private keys — so-called keyless storage. 
Ethereum enables sending ETH to pre-determined but non-existent addresses (computed using keccak256(rlp.encode[address, nonce])). Later, a contract can be deployed to that address and recover the funds. This provides a high level of anonymity, but requires extreme precision — any mistake in the nonce and the funds are lost forever.
