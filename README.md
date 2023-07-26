# Attack Vectors:

## Phantom Functions:
Phantom functions is a function that is not defined in a contract, but it is however called anyways and `DOES NOT REVERT`. For example, the ERC20 WETH token does not have the `permit()` standard function as some others ERC20 tokens, however, if called, it doesn't revert. It looks like these functions don't compile anymore - at least in Remix the unexisting function makes the compiler to throw an error. However, they may exist in DeFi protocols that handle integration of many tokens.

## xSushi-like enter/leave() for staking
A xSushi-like enter/leave function() is a code snippet like the one in the `attack_vectors/x_sushi_like.sol` file. It's widely used accross many protocols out there. The thing is that this code is vulnerable mostly only in the beginning of the deployment of the protocol on mainnets. The attack scenario is: 
1. an attacker is the first to deposit. Therefore, he holds all the shares so far minted since being the first depositor, he enters inside the `if()` statement. After he's deposited, he may front-run what should be the "first" depositor - which usually deposits a large amount of tokens - and `transfer()s tokens directly to the staking xSuShi-like contract`. Since the should-be first depositor deposits a large amount, now, totalShares() is much smaller than totalToken, since totalShares() will only increase after `amount` will be calculated, and when `amount` is calculated, the tokens transferred from the attacker to the contract will make totalShares / totalToke < 1, rounding down to 0. Therefore, the victim will receive no tokens, but there will be a great amount of tokens transferred in, since a whale is `enter()`ing. The attacker now can simply call `leave()`, and as the multiplication factor is the amount of tokens in the contract's balance - and the should-be "first" depositor increased it a lot - the attacker will go away with a huge amount of token! 
Useful link: [Attack Vector Explained](https://media.dedaub.com/latent-bugs-in-billion-plus-dollar-code-c2e67a25b689)

# Lecture Notes from the Expert Solidity Encode Bootcamp:

## Class 1:

1. There is an upcoming of  modular blockchains in the space: each new chain/protocol will be specialized in something unique like data availability, scalability, etc.
2. Account Abstraction will be good for introducing new more efficient signature schemes, like quantum-safe ones.
3. Digital signatures produce three identifiers, {r, s, v}. These can be checked to know if a message was true signed by the private key holding these variables - done through checking these variable against the public address of the account - but the private key cannot be derivated from these three variables.
4. Have fix value for the compiler version while testing, so that the production version is the same as the tested version.
5. External over public functions is no-more more advantegeous.

- [ ] Get the Lesson1.pdf and make an article about it.