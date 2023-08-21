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

## Class 7:
Some Encode CTF challenges.

## Class 8:
Gas Optimization:
1. Avoid repeteable code.
2. Break out of loops as early as possible
3. a(x) is low cost and b(x) is expensive, so the ordering should be:
a(x) || b(x)
a(x) && b(x)
4. If there's no need to store something, think of alternatives, like events.
5. Don't keep intermediate values in storage, only the final result of the calculations.
6. Costs of memory expansions increases quadratically, so rather than always expanding it, overwrite an no-more needed memory location.
7. Use bytes32 whenever, because it's the most optmized storage type.
8. bytes should be used over bytes[]
9. Mapping is cheaper than array, but the cost difference is always insignificant.
10. Uint8 isn't cheaper than uint256 because there are additional operations for a uint8 to fit the 32 bytes slots. It will be cheaper, of course, only if there's data types packing (the proccess of putting small variables types together in one slot).
11. Inheriting from a contract will bring its storage layout as well.
12. Public variables create a getter function, so it inscreases the size of the contract, increasing its cost. But, if I need it, I should declare it as public.
13. Calling a function is cheap, it only is a JUMP opcode.
14. Funtion selectors that are smaller will require less gas for being called. So, naming a function that will over and over with a simple and small name in hex is good.
15. Custom errors rather than assert and require.

# Class 12:

1. Simplicity > Complexity: Great example: MAKERDAO.
2. There are many libraries to handle percentages, decimals and other mathematical operations not natively supported by solidity. These are great to implement when developing DeFi products.
3. Uniswap libraries are great also since uniswap has gone through the whole DeFi history.
4. DOMAIN_SEPARATOR in EIP712 is useful for identifying a contract.
5. Permit approval function came because there was a necessity of abstracting away the `msg.sender`, since the `msg.sender` could not always send txs on-chain.
6. The `nonce` variable for the permit approval is NEEDED because it makes it impossible for replay attacks to happen.
7. Bitshifting allows compressing data.
8. `if iszero(x)` in assembly is much cheaper than `if x...` due to how JUMPI opcodes work.
9. Modifiers increase code size, so probably better to make them as functions.
10. Often, stablecoins intend to maintain their price pegged to something, like `dolar`, `gold`, etc.
11. LUNA's destruction happened because it interacted with a algorithmitic stablecoin called UST. 

## Class 13:

1. MEV searches are people who're looking for getting profits out of different ordering of transactions.
2. The most MEV attacks are of types: arbitrage and sandwhich attacks. But there's also other kind of MEV, like: liquidations.
3. As blocks are generated in every 12 seconds, there's enough time for MEV.
4. MEV may be good somehow: for example, some protocols trust in arbitrage being made all the time. 
5. Due to the competitive nature of MEV, gas prices can be enormous at times.
6. MEV may lead to centralization.
7. A Sandwhich attack is the combination of a front-running + a back-runnig transaction.
8. Generalized front-running happens by simulating the transaction in a forked blockchain and checking if there's a profit in that. If so, a bigger gas fee is sent to the mempool with the same calldata as it was passed in the original transaction.
9. MEV bots are incredibly profitable.
10. Artemis is a framework for building fast bots in Rust.
11. There's a way to make sure I won't be MEVed. That's by sending txs directly to FlashBots, instead of making them available in the public mempool.

## Questions: 
1. Is the DEXR Brazilian CDBC safe from MEV attacks? If not, how that may possible happen?

## Class 14:

This is probably the best paper lesson for me to study as part of what I'm building 

Tools: 
solc-verify
verisol
k language
Scribble
Halmos
ZIION

1. Symbolic Execution is more efficient to explore paths than fuzzind in Foundry because they use AST solvers.
2. Taint Analysis: similar to symbolic execution but it focuses on identifying inputs from third-parties, including users, that would compromise the program.
3. SMT-Checkers use the asserts and requires in order to be guided on where it can break the contract. It's quite easy to set up. It supports Foundry integration.
4. Echidna: fuzz tests. Interesting and it seems to be implemented on Slither. Check this later.
5. Scribble seems to be an excellent tool as well.
6. Halmos is very used by the teacher.
7. The detectors in slither are under slither/detectors. So, I can look into that when building my own static analyzer.
8. Check the ZIION tool: What a flip is this?

## Class 15:
1. Verkle trees are much more efficient in memory-size aspects than Merkle Trees.
2. There are current proposals for Ethereum to have compilers updated to support Rust, for example. Also, proposals for stateless Ethereum are a current thing. However, stateless Ethereum is not like Bitcoin, but rather having the purpose of dimishing the entry barrier for new nodes to get into the validation proccess.
3. Uniswap V4 may have drawn inspiration from Crocswap. Interesting!
4. Modifiers are compiled inline the function they're modifying. So, it's cheaper and more efficient to make them as functions if they're being used in multiple functions, since compiler just makes a JUMP to the functions instead of inlining their code multiple times they're called. 
5. Link of [Encode CTF](https://www.solidityctf.xyz)

## Class 16:
Workshop from Tellor - Oracle Service: 
1. Oracles also follow the descentralization-security-scalability dillema.
2. Mitigating sources and manipulation attacks: have multiple API sources. Also, choose a wise aggregation: VWAP, TWAP, etc. Also, fallback oracles are a good way to handle possible oracles down times.
3. Not only there needs to be multiple oracles, but if we've got multiple oracles and they've got the same data-source, then there's no profit in having multiple oracles. So, make sure I've got multiple oracles each with a different data-source.
4. The team should be able to be away the oracle protocol to still function correctly. ("We don't need Vitalik to make sure Ethereum runs")
5. When I create a company, protocol, whatever, write down my WHY and have it handy!
6. Do not get into debt to build something. If it's a good idea, VCs will give you money to build it. If not, you need to improve it!

# Tellor:
The way that Tellor works is:
Anyone can become a data-source, but they need to stake. When they provide data, they can disputed and lose 10% of their stake each time they provide bad data. So, there's an incentive for people to make sure the provided data is trust-worthy, because if not there's an incentive for others to profit on disputing the data provided.

# Marlin (Serveless Backends for Web3.0):
1. It's good for storing dynamic data: for example, if I want to store the a backend. Whereas IPFS is suitable for storing a static website - a website that only uses static files.

