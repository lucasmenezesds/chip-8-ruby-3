# frozen_string_literal: true

require "matrix"

module Chip8
  module Components
    # Chip-8's Registers' representation
    class Register
      attr_reader :index

      def initialize
        @index = 0x0 # 16-bit index, Index Register or Register, commonly named as "I"
        @variable = Array.new(0x10, 0x0) # 16 8-bit (one byte) general-purpose variable registers
      end

      def new_index(new_index)
        raise ArgumentError, "Invalid Index: #{new_index}" if new_index > 0xFFF # 4095

        @index = new_index
      end

      def set_variable(variable_pos, new_value)
        raise ArgumentError, "Invalid Variable Position: #{variable_pos}" if variable_pos > 0xF # 15
        raise ArgumentError, "Invalid New Value: #{new_value}" if new_value > 0xFF # 255

        @variable[variable_pos] = new_value
      end

      def add_to_variable(variable_pos, value_to_sum)
        raise ArgumentError, "Invalid Variable Position: #{variable_pos}" if variable_pos > 0xF # 15

        @variable[variable_pos] += value_to_sum # final_value

        @variable[variable_pos] = @variable[variable_pos] % 0xFF # dealing with the overflow
      end

      def new_display_data(register_x, register_y, n_pixels_tall, memory, display_buffer)
        @variable[0xF] = 0

        (0..(n_pixels_tall - 1)).each do |row|
          pos_y = @variable[register_y] % 32 + row # 0x20
          sprite_memory_address = @index + row
          sprite = memory.access(sprite_memory_address)

          break if pos_y > 0x1F # 31 # To stop drawing when leaving the screen

          draw_sprite_on_display_buffer(display_buffer, pos_y, register_x, sprite)
        end
        display_buffer
      end

      private

      def draw_sprite_on_display_buffer(display_buffer, pos_y, register_x, sprite)
        (0..7).each do |pixel_position|
          pos_x = @variable[register_x] % 64 + pixel_position # 0x40

          break if pos_x > 0x3F # 63 # To stop drawing when leaving the screen

          # the way we output in the screen is from the high bit to the low bit
          memory_pixel = (sprite & (1 << (7 - pixel_position))).positive? ? 1 : 0
          # memory_pixel = sprite.to_s(2).rjust(8, '0')[pixel_position].to_i # slower method

          screen_pixel = display_buffer[pos_x, pos_y] #  & 0x1

          display_buffer[pos_x, pos_y] = memory_pixel ^ screen_pixel

          # can be a bitwise operation as well
          @variable[0xF] = (memory_pixel && screen_pixel) || @variable[0xF]
        end
      end
    end
  end
end
