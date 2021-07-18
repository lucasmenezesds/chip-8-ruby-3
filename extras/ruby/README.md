# Some Ruby Programming Language Notes

- [Benchmarks](/extras/ruby/benchmarks/README.md)
- About Modules

## About Modules

### #include

When we call `#include MODULE` we're invoking the method `Module.append_features(mod)` and what it does is to add the
constants, methods, and module variables of this module to mod (if this module has not already been added to mod or one
of its ancestors.)

You can check one example of it's usage when the `FONTS`' constant is called
on [Chip8::Components::Memory](/lib/chip8/components/memory.rb)
that is including [Chip8::Components::Fonts](/lib/chip8/components/fonts.rb)

## About Reading Files

### File#open + String#upack

In this project we need to read the rom from a file...

The following command will open the file form the path passed, set the read mode *('rb' = read binary)* and then read
it.

```ruby
File.open(@rom_path, "rb", &:read) #=> "\x00\xE0"
```

After it, we need to convert the resulted string into a array of binary, and that why we use:

```ruby
.unpack('C*')
```

We have 2 instructions as parameters:

- `C` => Which is a directive to convert the strings into a 8-bit Unsigned Integer"

- `*` => Is to make the array size as big as the data, without empty positions.

More info about [File#open](https://ruby-doc.org/core-3.0.2/File.html#method-c-open)
and [String#unpack](https://ruby-doc.org/core-3.0.2/String.html#method-i-unpack)
