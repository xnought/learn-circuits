# Learn Circuits

Setup: directory with project and within a valid circuit like program (Verilog or other).

## To Learn

(When finished will include a link to the file)

- [Hello World](./hello-world/main.v)
- [Half Adder](./half-adder/main.v)
- [Full Adder](./full-adder/main.v)
- Unsigned Integer Adders: [4bit](./4bit-adder/main.v), [8bit](./8bit-adder/main.v), [nbit](./nbit-adder/main.v)
- Signed Integer Adders: [signed int](./signed-int/main.v) just simply reuses nbit with twos compliment representation
- Integer Multiplication
- Integer Division
- Floating point addition
- Floating point multiplication
- Floating point division
- bit registers

## Running

(example within the hello-world, but can apply to any dir)

```bash
cd hello-world
iverilog main.v
./a.out
```
