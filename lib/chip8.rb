# frozen_string_literal: true

require_relative "chip8/version"
require_relative "chip8/interpreter"

# Chip-8 Application's module
module Chip8
  class Error < StandardError; end

  # Chip-8 Emulator, its setup everything to run the emulator(interpreter)
  class Emulator
    def initialize(rom_path:)
      @rom_path = rom_path
      @cpu = Chip8::Interpreter.new
    end

    def run
      bytecode_data = read_cartridge
      @cpu.load_rom(bytecode_data)

      Thread.new do
        @cpu.run
      end

      @cpu.show_display
    end

    private

    def read_cartridge
      File.open(@rom_path, "rb", &:read).unpack("C*")
    end
  end
end
