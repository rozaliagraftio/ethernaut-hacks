// import `utils` object from `ethers` library
const { utils } = require("ethers");
// import `keccak256` function from `utils` object
const { keccak256 } = utils;
// import `rlp` object from `rlp` library
const rlp = require("rlp");

// instance address - address of Recovery Contract
const sender = "0xfE7507EFfFA95008cFFa021B0e32216AFf730fcB";
// the parameter nonce is equal to 1 (cause we deploy the first contract)
const nonce = 1;
// encode sender + nonce into bytes string via RLP
const encoded = rlp.encode([sender, nonce]);
// get the hash of serialized data via keccak256
const hash = keccak256(encoded); // 0x + 64 hex characters
// extract the last 20 bytes (40 hex characters)
const contractAddress = "0x" + hash.slice(26); // 0x + 40 hex characters (64 - 24 = 40 symbols = 20 bytes)
// output the computed contract address
console.log("Address:", contractAddress);
