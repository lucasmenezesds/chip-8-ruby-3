# frozen_string_literal: true

require_relative "./fonts"

module Chip8
  module Components
    # Chip-8s RAM representation
    class Memory
      include Chip8::Components::Fonts # making constants, etc from the module  available on the current class.

      RAM_STARTING_ADDRESS = 0x000
      RAM_ENDING_ADDRESS = 0x1FF
      PROGRAMS_STARTING_ADDRESS = 0x200
      TOTAL_MEMORY_SIZE = 0x1000 # 4096 Addresses => "4 kB of RAM"

      attr_reader :memory

      def initialize
        # Starting a array of 4096 positions with 0 wrote on all of it
        @memory = Array.new(TOTAL_MEMORY_SIZE, 0x0)
        load_fonts_into_memory
      end

      def update_value(array_position, new_value)
        @memory[array_position] = new_value
      end

      def load_fonts_into_memory
        FONTS.each_with_index do |byte, index|
          current_position = FONT_STARTING_ADDRESS + index
          update_value(current_position, byte)
        end
      end

      def clean
        @memory = Array.new(TOTAL_MEMORY_SIZE, 0x0)
      end

      def access(array_position)
        return @memory[PROGRAMS_STARTING_ADDRESS] if array_position > TOTAL_MEMORY_SIZE - 1

        @memory[array_position]
      end

      def load_rom(bytecode)
        bytecode.each_with_index do |byte, index|
          current_position = PROGRAMS_STARTING_ADDRESS + index
          update_value(current_position, byte)
        end
      end
    end
  end
end
