# Chip-8 Emulator in Ruby 3

Hi! This project is called "CHIP-8 emulator" in Ruby 3 but actually, CHIP-8 is an interpreted programming language, and
I'll be implementing it...

Anyway if you're interested on knowing more about it, you can check [here](https://en.wikipedia.org/wiki/CHIP-8).

### Extras

If you you don't know from where to start or is wondering about some parts of the process of developing this project,
you can check the [extra section](/extras/README.md), where I wrote down some notes that maybe could be helpful.

## Installation

**If you're using debian based distro:**

You can just run `bin/setup` from the root path of the project.

**OR**

### Linux dependencies for both C++ and Ruby

_Debian Based Distros_

```bash
$ sudo apt install build-essential libsdl2-dev libgl1-mesa-dev libopenal-dev \
libgmp-dev libfontconfig1-dev
```

#### Other O.S.

Gosu's Gem require couple libs to be installed on your environment, for more information you can check
it [here](https://github.com/gosu/gosu/wiki#installation)

### Project's Dependencies

```bash
$ bundle install
```

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies (_If you're using Debian based linux distros,
otherwise check the **Other O.S'** section_).

Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to
experiment.

## Other information

### Gems' Details

Detailing the reason on for gems that are non-common gems used in this project.

#### Gosu

"2D game development library. Gosu provides simple and game-friendly interfaces to 2D graphics and text (accelerated by
3D hardware), sound samples and music as well as keyboard, mouse and gamepad/joystick input."

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lucasmenezesds/chip-8-ruby-3. This project is
intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to
the [code of conduct](hhttps://github.com/lucasmenezesds/chip-8-ruby-3/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CHIP-8-ruby-3 project's codebases, issue trackers, chat rooms and mailing lists is expected
to follow the [code of conduct](hhttps://github.com/lucasmenezesds/chip-8-ruby-3/blob/master/CODE_OF_CONDUCT.md).
