1. Look at the example of init code in today's notes
See [gist](https://gist.github.com/extropyCoder/4243c0f90e6a6e97006a31f5b9265b94)
When we do the CODECOPY operation, what are we overwriting ?
(debugging this in Remix might help here)

2. Could the answer to Q1 allow an optimisation?

3. Can you trigger a revert in the init code in Remix ?
No, I couln't by myself. The opcodes available for the init code in Remix are only the PUSH1 0x80 and PUSH1 0x40, and then a MSTORE which sets the 0x80 on the stack as value in the free memory pointer.

- [x] DONE
4. Write some Yul to:
    1.Add 0x07 to 0x08
    2.store the result at the next free memory location
    3.(optional) write this again in opcodes

- [x] DONE
5. Can you think of a situation where the opcode EXTCODECOPY is used?
Yes, for example, when a contract calls the UniSwapRouter swapExactTokensForTokens() function.

- [x] DONE
6. Complete the assembly exercises in this [repo](https://github.com/ExtropyIO/ExpertSolidityBootcamp)