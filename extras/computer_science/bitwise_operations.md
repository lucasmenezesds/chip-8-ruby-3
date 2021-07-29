# Bitwise Operations

## Table of Contents

1. Intro
2. Nibble
3. Usefulness of it on CHIP 8's implementation.
4. `&` (AND [**Extract**])
5. `|` (OR [**Set**])
6. `^` (XOR)
7. `<<` and `>>` (Shifting [left/right])

## Intro

During the development of the project I had to use the bitwise operations quite ofter in order to make work with some
information...

In simple terms, bitwise operations are operations that works on bits(one bit, an array of bits or a binary number)
performing bit by bit operations...

In this project I used almost all the operations (except for the NOT(~)). In the end we can simplify the AND, OR and
XOR, since it works the same way in a Truth Table but bit by bit, I'll explain a little bit about how I used those in
the project, but If you want to read more then you can have a
check [here](https://en.wikipedia.org/wiki/Bitwise_operation)
and [here](https://www.tutorialspoint.com/ruby/ruby_operators.htm)

## Nibble

Nibbles are basically a 'half a byte', in other words, a group of 4 bits.

- 1 Nibble = `4 bits`
- 2 Nibbles = `1 Byte`
- 4 Nibbles = `1 Word` or `2 Bytes` or `16 bits `

---
**NOTE***:

Is important to say that we starting counting the nibbles from the Most Significant Bit to the Least Significant Bit.

The Chip-8 Instructions are 16 bits, so 4 nibbles...

```
1111101010011100

1111 1010 1001 1100
[1]  [2]  [3]  [4]
```

In this case the nibbles are:

```
1st Nibble = 1111
2nd Nibble = 1010
3rd Nibble = 1001
4th Nibble = 1100
```

**NOTE2**:

Most Significant Bit and Least Significant Bit can be called in different ways, for example:

- Most Significant Bit (**MSB**) => `High Bit` or `Upper Bit`

- Least Significant Bit (**LSB**) => `Low Bit` or `Lower Bit`

---

## Usefulness on the CHIP 8's implementation

In the case of this project, since CHIP 8's instructions are 16 bits.

Depending on the instructions, it's easier if we have some specific nibbles separated, so extracting them can simplify
the execution process.

## `&` Bitwise AND (Extract)

As I wrote above you can consider the bitwise AND work like the truth table works, but for bits, so...

```
1 & 1 = 1
1 & 0 = 0
0 & 1 = 0
0 & 0 = 0
```

Right below is how a bitwise operation will work.

Let's Imagine that I have the following instruction:

- `0x6120`(hexadecimal)
- `0b0110000100100000` (same but in binary)

*Splitting to make it easier to read:*

```
0110 0001 0010 0000 
```

I would like to extract only the first nibble(ignoring the rest)... To do that we would do something like:

Binary representation:

```
0110 0001 0010 0000 
1111 0000 0000 0000 &
-------------------
0110 0000 0000 0000
```

Hexadecimal representation:

```
0x6120       => 0110 0001 0010 0000 
0xF000 &     => 1111 0000 0000 0000
------
0x6000       => 0110 0000 0000 0000
```

--------
**Example #2**

Let's Imagine that now we want the Nibbles 2 and 3...

The code would be like this:

Binary representation:

```
0110 0001 0010 0000 
0000 1111 1111 0000 &
-------------------
0000 0001 0010 0000
```

Hexadecimal representation:

```
0x6120       => 0110 0001 0010 0000 
0x0FF0 &     => 0000 1111 1111 0000
------
0x0120       => 0000 0001 0010 0000
```

-------

## `|` Bitwise OR (Set)

The bitwise OR works the same way as well:

```
1 | 1 = 1
1 | 0 = 1
0 | 1 = 1
0 | 0 = 0
```

An usage example is when I want to set 2 8-bits instructions into a 16-bits.

Let's imagine I have the following data:

- **Full instruction**
    - `0x6121` (hexadecimal)
    - `0b0110000100100001` (binary)


- **First 2 nibbles:**
    - `0x6100` (hexadecimal)
    - `0b0110000100000000` (binary)


- **Last 2 nibbles:**
    - `0x0021` (hexadecimal)
    - `0b0000000000100001` (binary)

This is how it would work...

Binary representation:

```
0110 0001 0000 0000
0000 0000 0010 0001 |
-------------------
0110 0001 0010 0001
```

Hexadecimal representation:

```
0x6100       => 0110 0001 0000 0000 
0x0021 |     => 0000 0000 0010 0001
------
0x6121       => 0110 0001 0010 0001
```

-----

## `^` Bitwise XOR

The bitwise XOR also works like in the truth table, in other words, if both are equal then 0, else 1:

```
1 ^ 1 = 0
1 ^ 0 = 1
0 ^ 1 = 1
0 ^ 0 = 0
```

You could be asking where this could be useful for CHIP-8.. And one of the reasons is, on the display..

Imagine that you need to "toggle" some pixels of the screen... So we can use the bitwise XOR to figure out which are the
ones you need to change..

For example, given that we have a "display" of 1x8 (yes, a line xD, but if you want to understand more I recommend you
reading the [Font's part](/extras/chip-8/fonts.md)).

We have the "positions" we want to turn on/off named `memory_pixels` that is a 8 bit data, and our current display named
as `screen_pixels` (also a 8 bit data), that have already something that is being displayed as represented below.

- memory_pixels = `1100 0011` (want to turn off the edges of the screen)
- screen_pixels = `1111 1111` (everything is on)

If we want to turn some pixels on and other off, we can just apply a bitwise XOR!

Binary representation:

```
1100 0011    => memory_pixels
1111 1111 ^  => screen_pixels
-------------------
0011 1100
```

-----
**NOTE**: The flickering is common in the CHIP-8.

## `<<`/`>>` Bit Shift

Lastly, the bit shifting...

And it's basically "moves" the bits to the left(`<<`) or to the right(`>>`) N positions.... Mathematically speaking,
we're multiplying by 2^N (when is to the left) and dividing by 2^N (when is to the right).

**Example #1**

```
0000 1111 << 1 (15 in decimal)
-------------------
0001 1110 (30 in decimal)

```

**Example #2**

```
0000 1010 >> 1 (10 in decimal)
-------------------
0000 0101 (5 in decimal)
```

-----

But, why this could be useful in this CHIP's 8 project!? Remember the **bitwise OR** example? That I need to "merge" 2
8-bits data in 16-bits? To do that without "losing" any information we can use bit shifting!

For example, we have the following nibbles:

- **First 2 nibbles:**
    - `0x60` (hexadecimal)
    - `0b01100000` (binary)


- **Second 2 nibbles:**
    - `0x20` (hexadecimal)
    - `0b00010000` (binary)

- **What we want/need**
    - `0x6120` (hexadecimal)
    - `0b0110000100100000` (binary)

This is how it works...

first we move the first 2 nibbles, making space for the other 2 nibbles we will set later.

```
0110 0001 << 8       => 0x61 (Hexadecimal)
----------------
0110 0001 0000 0000  => 0x6100 (Hexadecimal)
```

and now since everything after the `61` is `0` we can set(`|`) the other part without problem..

```
0x6100       => 0110 0001 0000 0000 
0x0020 |     => 0000 0000 0010 0000
------
0x6120       => 0110 0001 0010 0000
```

Another part of the project that shift was used was in the display part, which when we "draw" something using bits we
always start **from** the Most Significant Bits **to** the Least Significant Bits...

----
...

Well, that's it! I hope the explanations could help you a little!


