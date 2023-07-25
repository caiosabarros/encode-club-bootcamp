# Attack Vectors:

## Phantom Functions:
Phantom functions is a function that is not defined in a contract, but it is however called anyways and `DOES NOT REVERT`. For example, the ERC20 WETH token does not have the `permit()` standard function as some others ERC20 tokens, however, if called, it doesn't revert. It looks like these functions don't compile anymore - at least in Remix the unexisting function makes the compiler to throw an error. However, they may exist in DeFi protocols that handle integration of many tokens.

# Lecture Notes from the Expert Solidity Encode Bootcamp:

## Class 1:

1. There is an upcoming of  modular blockchains in the space: each new chain/protocol will be specialized in something unique like data availability, scalability, etc.
2. Account Abstraction will be good for introducing new more efficient signature schemes, like quantum-safe ones.
3. Digital signatures produce three identifiers, {r, s, v}. These can be checked to know if a message was true signed by the private key holding these variables - done through checking these variable against the public address of the account - but the private key cannot be derivated from these three variables.
4. Have fix value for the compiler version while testing, so that the production version is the same as the tested version.
5. External over public functions is no-more more advantegeous.

- [ ] Get the Lesson1.pdf and make an article about it.