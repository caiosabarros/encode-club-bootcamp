1. What are the disavantages and advantages of the 256 bit word length in Ethereum?
It makes it better for hashing algorithms, like the keccak256, which use the 256 word length.

2. What would happen if implementations of precompiled contracts in Ethereum clients varied?
From RareSkills:

Ethereum precompiles behave like smart contracts built into the Ethereum protocol. The nine precompiles live in addresses 0x01 to 0x09.
The utility of precompiles falls into four categories
Elliptic curve digital signature recovery
Hash methods to interact with bitcoin and zcash
Memory copying
Methods to enable elliptic curve math for zero knowledge proofs

These operations were deemed desirable enough to have gas-efficient mechanisms for doing them. Implementing these algorithms in Solidity would be considerably less gas efficient.
Precompiles do not execute inside a smart contract, they are part of the Ethereum client specification

So, precompiled contracts are contracts built into the Ethereum clients - they're even mentioned in the Yellow Paper for any client specification. If there were different precompiled contracts accross different clients, there'd be a fork of each client, creating a new chain, since they'd get different results for different operations done in these precompiled contracts.

3. Using Remix write a simple contract that uses a memory variable, then
using the debugger step through the function and inspect the memory.