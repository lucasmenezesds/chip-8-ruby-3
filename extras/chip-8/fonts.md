# CHIP-8's Font

So, since CHIP-8's time there were no fonts, we need to create it... And we do that by using Hexadecimal notation (that
later will be converted to binary)...

You can imagine something like being a type of "ASCII Art", but on 8bits structures.

And to make it easier to understand, I'll show couple examples...

Here are some data as example:

Imagine each position of those "arrays" as a line, and lets convert each hexadecimal into binary notation...

```
0xF0, 0x90, 0x90, 0x90, 0xF0, // 0
0xF0, 0x10, 0xF0, 0x10, 0xF0, // 3
0xF0, 0x90, 0xF0, 0x90, 0x90, // A
0xF0, 0x80, 0xF0, 0x80, 0x80  // F
```

converting it to binary:

`0xF0 => 0b11110000`

`0x90 => 0b10010000 `

`0x90 => 0b10010000 `

`0x90 => 0b10010000 `

`0xF0 => 0b11110000`

If we put them closer it bem something like this:

```
0xF0 => 0b11110000
0x90 => 0b10010000 
0x90 => 0b10010000
0x90 => 0b10010000
0xF0 => 0b11110000
```

Now if we remove the everything before `0b` and the `0` adding some spaces...

```
1 1 1 1    
1     1    
1     1    
1     1    
1 1 1 1    
```

Looks like a Zero, right!? Now let's do it with the F as the second(and last) example.

converting it to binary:

`0xF0 => 0b11110000`

`0x80 => 0b10000000`

`0xF0 => 0b11110000`

`0x80 => 0b10000000`

`0x80 => 0b10000000`

Putting everything together...

```
0xF0 => 0b11110000
0x80 => 0b10000000
0xF0 => 0b11110000
0x80 => 0b10000000
0x80 => 0b10000000
```

And removing the everything before `0b` and the `0` adding some spaces...

```
1 1 1 1
1
1 1 1 1
1
1
```

And that's how something was 'wrote' on the screen :) 