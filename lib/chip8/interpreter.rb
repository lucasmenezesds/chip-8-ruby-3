# frozen_string_literal: true

require_relative "components"

module Chip8
  # The Chip-8 Interpreter AKA CPU
  class Interpreter
    include Chip8::Components

    def initialize
      @cpu_status = CPUStatus.new
      @display = Display.new(@cpu_status)
      @memory = Memory.new
      @program_counter = ProgramCounter.new(starting_index: Memory::PROGRAMS_STARTING_ADDRESS)
      @register = Register.new
      @opcode = nil
      @nibbles = { "instruction" => nil, "x" => 0, "y" => 0, "n" => nil, "nn" => nil, "nnn" => nil }
    end

    def cpu_cycle
      fetch
      decode
      execute
    end

    def run
      loop do
        cpu_cycle
        break if @cpu_status.stopped
      end
    end

    def load_rom(bytecodes)
      @memory.load_rom(bytecodes)
    end

    def show_display
      @display.show
    end

    private

    # Fetch the instruction from memory at the current PC (program counter)
    def fetch
      current_pc_pos = @program_counter.index

      first_instruction_part = @memory.access(current_pc_pos) # Fetching the first Byte
      second_instruction_part = @memory.access(current_pc_pos + 1) # Fetching the second Byte
      shifted_first_instruction_part = first_instruction_part << 8 # bitwise shifting

      @opcode = (shifted_first_instruction_part | second_instruction_part) # bitwise OR

      @program_counter.increment_index_position

      nil
    end

    # Decode the instruction to find out what the emulator should do
    def decode
      # Since CHIP-8 Uses Big-Endian notation we do as following
      # Instruction
      @nibbles["instruction"] = (@opcode & 0xF000) >> 12 # getting the first nibble & converting to 4 bit value

      # X and Y
      @nibbles["x"] = (@opcode & 0x0F00) >> 8 # getting the second nibble from 2 bytes data & converting to 4 bit value
      @nibbles["y"] = (@opcode & 0x00F0) >> 4 # getting the third nibble from 2 bytes data and converting to 4 bit value

      # 4,8 and 12 bits instructions
      @nibbles["n"] = @opcode & 0x000F # getting the fourth nibble from 2 bytes data
      @nibbles["nn"] = @opcode & 0x00FF # getting the third and fourth nibbles(second byte) from 2 bytes data
      @nibbles["nnn"] = @opcode & 0x0FFF # getting the second nibble from 2 bytes data

      nil
    end

    # Execute the instruction and do what it tells you
    def execute
      Instructions.run(@nibbles,
                       display: @display,
                       register: @register,
                       program_counter: @program_counter,
                       memory: @memory)
    end
  end
end
