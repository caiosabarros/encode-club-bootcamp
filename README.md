# Attack Vectors:

## Phantom Functions:
Phantom functions is a function that is not defined in a contract, but it is however called anyways and `DOES NOT REVERT`. For example, the ERC20 WETH token does not have the `permit()` standard function as some others ERC20 tokens, however, if called, it doesn't revert. It looks like these functions don't compile anymore - at least in Remix the unexisting function makes the compiler to throw an error. However, they may exist in DeFi protocols that handle integration of many tokens.

## xSushi-like enter/leave() for staking
A xSushi-like enter/leave function() is a code snippet like the one in the `attack_vectors/x_sushi_like.sol` file. It's widely used accross many protocols out there. The thing is that this code is vulnerable mostly only in the beginning of the deployment of the protocol on mainnets. The attack scenario is: 
1. an attacker is the first to deposit. Therefore, he holds all the shares so far minted since being the first depositor, he enters inside the `if()` statement. After he's deposited, he may front-run what should be the "first" depositor - which usually deposits a large amount of tokens - and `transfer()s tokens directly to the staking xSuShi-like contract`. Since the should-be first depositor deposits a large amount, now, totalShares() is much smaller than totalToken, since totalShares() will only increase after `amount` will be calculated, and when `amount` is calculated, the tokens transferred from the attacker to the contract will make totalShares / totalToke < 1, rounding down to 0. Therefore, the victim will receive no tokens, but there will be a great amount of tokens transferred in, since a whale is `enter()`ing. The attacker now can simply call `leave()`, and as the multiplication factor is the amount of tokens in the contract's balance - and the should-be "first" depositor increased it a lot - the attacker will go away with a huge amount of token! 
Useful link: [Attack Vector Explained](https://media.dedaub.com/latent-bugs-in-billion-plus-dollar-code-c2e67a25b689)

## Harvest Yield Skimming:
The flow of the attack is as follows:
1. Since the `harvest()`-like function will swap token A for token B, attacker swaps tokenA for tokenB, providing a lot of tokenA to the pool.
2. Since the pool holds a lot of tokens A, tokens A's price compared to B's is much more cheaper (since there's abundance of A when compared to B in the pool).
3. Now, attacker calls `harvest()` on contract, therefore making the swap from the victim contract from tokens A for tokens B, but since now A's tokens are much more abundant in the pool, contract will receive much less tokens B that it would initially. (First hack).
4. Now, since the attacker holds much more tokens B than the victim contract - since he's swapped them at a lower price - he can use his very valuable tokens B to get tokens As back - receiving profit, since there'll be much more tokens As in the uniswap contract, since the victim contract has added even more, making the tokens B even more valuable.

Useful Link: [Public Harvest Attack Vector Explained](https://medium.com/dedaub/yield-skimming-forcing-bad-swaps-on-yield-farming-397361fd7c72)

# Lecture Notes from the Expert Solidity Encode Bootcamp:

# WEEK 1:
## Class 1:

1. There is an upcoming of  modular blockchains in the space: each new chain/protocol will be specialized in something unique like data availability, scalability, etc.
2. Account Abstraction will be good for introducing new more efficient signature schemes, like quantum-safe ones.
3. Digital signatures produce three identifiers, {r, s, v}. These can be checked to know if a message was true signed by the private key holding these variables - done through checking these variable against the public address of the account - but the private key cannot be derivated from these three variables.
4. Have fix value for the compiler version while testing, so that the production version is the same as the tested version.
5. External over public functions is no-more more advantegeous.

- [ ] Get the Lesson1.pdf and make an article about it.

## Class 2:
1. It's not a good practice to modify state inside modifiers though they can be, but the modifiers are usually seen as checkers for reading state, not writing it.
2. Currently, the solidity compiler repeats the modifier code wherever they're used. But, there's a current discussion on this.
3. In a child contract, the storage layout will be different according to the way inheritance has been setup.
4. `Calldata` parameters can't be changed inside the function body.
5. `assert` should be used for handling internal errors and to check invariants, while `revert` is usually used for checking user proper interaction.
6. Custom errors allow for better readibility and also are more efficient than having require's or assert's.
7. The imported contract's bytecodes are placed with the bytecode of your code.
8. For contracts with lots of imports, they need to be flattened with the original contract to be deployed.
9. Library is a smart contract with no state. Their function run in the context of my contract.
10. There are allowed custom types in solidity, and these are based on the ordinary types we've been used to.

## Class 3:
1. All the aspects of the EVM are non-physical. Their names are just a way to represent the abstract machine.
2. Storing data on-chain is cheaper by storing it as bytecode - a contract that really is not a contract in the widely-used sense.
3. Push adds elements onto the stack, pop removes the top element of the stack. There are 1024 elements available in the stack - each being 32 bytes. If we try to make an operation is deeper than the first 16 elementes, we get the "stack too deep error"
4. Call Stack in the EVM: it is the stack that keeps track of the calls made by stacks.
5. Free Memory Pointer is a way to avoid memory's overrides in specific slots to avoid losing data.
6. Storage is different from memory in that storage has a key-value pair layout. So, that's why some proxy contracts save something in some specific slot rather than increasing the slots one-by-one, like in memory. Also, memory is contiguous (one after another).
7. Dinamically-sized variables are stored inside a slot occupying 32 bytes. But the variable is only a link to another storage slot that will actually hold the key values and values values in the dinamically-sized variable.
8. We can look at the `delegatecall` as a proxy contract executing implementation contract's bytecode inside the proxy.   

- [ ] Append the memory layout picture in here.= inside lesson 3's pdf.
- [ ] Look at the references at the end of the lesson's pdfs.

## Class 4:
1. Different Approaches to upgradeability: 
- [ ] data migration problem
- [ ] Registry: data migration problem 
- [ ] Function and data contracts separately
- [ ] Strategy pattern: GnosisSafe. Approach is additive.
- [ ] Proxy: it's kind of a function and data contracts approach as well.
- [ ] Eternal Storage: it's not recommended since there needs to be a awareness is all the values of all the variables that will be in storage.
2. Implementation and Proxies need to have the same storage layout.
3. Always only append new items that are going to write to storage. Do not place the new storage data before the end of the storage layout.
4. Proxied/Implementation contracts do not need to have a constructor, since the state initialized inside the constructor will only be available at the proxied contract, therefore, we won't be able to modify that state through `delegatecall`. It's not a problem in itself by having a constructor, but it's needless.
5. The plugins - like the hardhat-upgrades - deploys a proxy and an implementation contract. It is taken care by the `.deployProxy()` function.
6. Test upgrading the implementation in the unit tests, don't leave to test it in production or never test. 
7. Diamond proxies are good because each function() is a different implementation contract (faucet) and therefore, there aren't that many functions in just one contract - having been submisse, therefore, to the 24Kb contract-size limit.
8. The famous `initialize()` function should only be in the proxy contract, not in the proxied contract since state will be stored in the proxy contract.
9. Foundry also supports debugging.  
## Questions of Class 4:
1. What are the main differences between UUPS and Transparent Proxies patterns?
2. What are invariante tests in Foundry?
3. What's a Model checker in Foundry?
It is basically a compiler that already pre-tests the contract. It's not enabled by default.
4. What's Differential testing in Foundry?
5. What's tenderly for debugging?

# WEEK 2:

## Class 5:

1. When an `overflow` kind of error happens in solidity runtime compiler, it means the error actually comes from the stack, because the code is actually being executed at the stack-level.
2. HUFF > Yul when it comes to optimization.
3. There are two kind of Yul notations:
Standard Notation: a+b
Reverse Polish Notation: a b add (which is same as a+b in standard notation)
4. In the following example:
Program Counter (looks at the bytecode list to be performed sequentially):
```
PUSH1 2
PUSH1 4
ADD
``` 
Description: We place 2 onto the stack. The 2 is left padded. Then, there's a placement of 4 onto the stack. Then, 4 is at the top of the stack and 2 is right below it. Then comes the ADD opcode to add these two top items in the stack, resulting in 6 as the top of the stack.
5. The ?????? questions marks in remix debugger arre probably some non-ASCII caracter that can't be displayed.
6. The `init code` is run whenever we deploy a contract. It:
- First sets the memory pointer at 0x80 memory address.
Then it runs on with the constructor's bytecode: The init code is always run, because there are some contract's without constructor.
- It checks if any ether is sent in the constructor and reverts if the constructor is non-payable.
- it performs what the specific constructor wants.
7. When `wei` is sent in a tx, it's placed on the top of the stack.
8. When we can a message CALL from a contract to another one, it writes the arguments to memory, it sets some place where the return value will be stored in memory, and then it copies the bytecode of the called through EXTCODECOPY (I guess it's this one) opcode and it executes the bytecode of the called contract through the copied bytecode.
9. The opcodes don't get on memory, they get on the stack. On memory are only the memory values in memory contiguous addresses.
10. An assembly block, we CAN referrence variables that aren't defined inside assembly block.
11. EXCODECOPY differs from CODECOPY because it copies the bytecode from an external contract, whereas the later copies the bytecode from itself.

## Questions:
1. What's a precompiled contract?
Answer: These contracts are contracts implemented by developers of the blockchain clients and are useful for client functionaçity, not contracts implemented by developers of smart contracts.

## Class 6:
1. Error handling in YUL isn't the best thing of theirs.
2. YUL may be used not in conjunction with Solidity, it can be used in a whole smart contract.