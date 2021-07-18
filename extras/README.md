# Extras

In order to be able to develop this project I had to review some Computer Science's topics.. So I decided to write some
notes so maybe this could be useful for someone ^ ^.

## Table of Contents

- Current Document
    - TODO
- [Ruby](/extras/ruby/README.md)
- [Chip-8](/extras/chip-8/README.md)

## Computer Organization and Architecture

If you need some source of information in order to remember(or learn) a little about how a CPU works, then I would
recommend you to have a check on the following two videos:

+ [Beyond FPS: How does a CPU work? - NGON](https://www.youtube.com/watch?v=DSamxtiCIyM)

+ [Beyond FPS: What does a CPU do? - NGON](https://www.youtube.com/watch?v=Yq-SpmIgmGs)

If you want to check all the videos, then here is
the [playlist](https://www.youtube.com/watch?v=DSamxtiCIyM&list=PLcKpytGyWm9o6SHKuag4Rj-J_0yQxJ4PV

**NOTE:**
If you speak *Portuguese*, você pode checar este [video do Fábio Akita](https://www.youtube.com/watch?v=hYJ3dvHjeOE)

## Bit, Bytes, etc~

[Bit (b)](https://en.wikipedia.org/wiki/Bit) => **0** or **1**

[Byte (B)](https://en.wikipedia.org/wiki/Byte) => **8 bits** => 0000 0000 ~ 1111 1111

[Kilobyte (KB)](https://en.wikipedia.org/wiki/Kilobyte) => **1 024 Bytes** (2^10 Bytes)

- **1KB** =
    - 1 024 Bytes
    - 8 192 Bits

- **1 Byte** = 8 bits
    - Binary: 1111 1111 (0b11111111)
    - Hexa: FF (0xFF)

- **2 Bytes** = 16 bits
    - Binary: 1111 1111 1111 1111 (0b1111111111111111)
    - Hexa: FFFF (0xFFFF)

## Decimal, Binary and Hexadecimal Numbers

**Why to use Hexadecimals instead of numbers?**

- Basically because it's easier to do conversions and manage things when we're considering bits, bytes.

    - For example:
        - 0xF => 15 (decimal) => 1111 (binary)
        - 0xFFFF => 65535 (decimal) => 1111111111111111 (binary)

- Besides that, you can have a better/faster (mental) representation of how the bits are organized...

    - For example:
        - If there is a `0xF`, you'll know that all the bits are `1`;
        - If there is a `0x9` you'll know that the bits are `1001`, and so on.

More Info: [here](http://www.eecs.umich.edu/courses/eecs270/270lab/270_docs/HexNumSys.pdf)
, [here](https://en.wikipedia.org/wiki/Hexadecimal) and [here](https://www.youtube.com/watch?v=yOyaJXpAYZQ)

### Suffix

- Decimal: `0d` (Optional)
- Binary:  `0b`
- Hexadecimal: `0x`

### Table

This is a simple table converting some decimal values into binary and hexadecimal values (maybe can help you visualize
something xD).

|    Decimal   | Binary | Hexadecimal |
|    :----:    | :----: |    :----:   |
| 0            | 0000   | 0           |
| 1            | 0001   | 1           |
| 2            | 0010   | 2           |        
| 3            | 0011   | 3           |
| 4            | 0100   | 4           |
| 5            | 0101   | 5           |
| 6            | 0110   | 6           |
| 7            | 0111   | 7           |
| 8            | 1000   | 8           |
| 9            | 1001   | 9           |
| 10           | 1010   | A           |
| 11           | 1011   | B           |
| 12           | 1100   | C           |
| 13           | 1101   | D           |
| 14           | 1110   | E           |
| 15           | 1111   | F           |

-------------
