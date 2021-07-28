# frozen_string_literal: true

require "matrix"
require_relative "display"

module Chip8
  module Components
    # Chip-8s Registers' representation
    class Register
      attr_reader :index

      def initialize
        @index = 0x0 # 16-bit index, Index Register or Register, commonly named as "I"
        @variable = Array.new(0x10, 0x0) # 16 8-bit (one byte) general-purpose variable registers
      end

      def update_index(new_index)
        raise ArgumentError, "Invalid Index: #{new_index}" if new_index > 0xFFF # 4095

        @index = new_index
      end

      def get_variable_in_position(variable_pos)
        raise ArgumentError, "Invalid Variable Position: #{variable_pos}" if variable_pos > 0xF # 15

        @variable[variable_pos]
      end

      def set_variable_in_position(variable_pos, new_value)
        raise ArgumentError, "Invalid Variable Position: #{variable_pos}" if variable_pos > 0xF # 15
        raise ArgumentError, "Invalid New Value: #{new_value}" if new_value > 0xFF # 255

        @variable[variable_pos] = new_value
      end

      def add_to_variable(variable_pos, value_to_sum)
        raise ArgumentError, "Invalid Variable Position: #{variable_pos}" if variable_pos > 0xF # 15

        @variable[variable_pos] += value_to_sum # final_value

        @variable[variable_pos] = @variable[variable_pos] & 0xFF # handle the overflow
      end

      def copy_variable_data_from_to(from_pos_y, to_pos_x)
        validate_position_ranges(to_pos_x, from_pos_y)
        @variable[to_pos_x] = @variable[from_pos_y]
      end

      def bitwise_logical_or(pos_x, pos_y)
        validate_position_ranges(pos_x, pos_y)
        @variable[pos_x] = @variable[pos_x] | @variable[pos_y]
      end

      def bitwise_logical_and(pos_x, pos_y)
        validate_position_ranges(pos_x, pos_y)
        @variable[pos_x] = @variable[pos_x] & @variable[pos_y]
      end

      def bitwise_logical_xor(pos_x, pos_y)
        validate_position_ranges(pos_x, pos_y)
        @variable[pos_x] = @variable[pos_x] ^ @variable[pos_y]
      end

      def bitwise_logical_shift(pos_x, pos_y, to_right: true)
        validate_position_ranges(pos_x, pos_y)
        vx = @variable[pos_x]
        vy = @variable[pos_y]

        if to_right
          @variable[pos_x] = (vy >> 1) & 0xFF # To avoid overflow
          @variable[0xF] = (vx & 0x01) # 0b1 (extracting the low bit)
        else
          @variable[pos_x] = (vy << 1) & 0xFF # To avoid overflow
          @variable[0xF] = (vx & 0x80) >> 7 # 0x80 # 0b10000000 (extracting the high bit)
        end
      end

      def sum_variable_from_into(pos_y, pos_x)
        validate_position_ranges(pos_x, pos_y)

        final_value = @variable[pos_x] + @variable[pos_y]
        @variable[0xF] = final_value > 0xFF ? 0x1 : 0x0

        @variable[pos_x] = final_value & 0x00FF
      end

      def subtract_variables(first_op, second_op, var_destination:)
        @variable[0xF] = @variable[first_op] > @variable[second_op] ? 0x1 : 0x0

        final_value = @variable[first_op] - @variable[second_op]

        @variable[var_destination] = final_value & 0xFF
      end

      def set_random_value_into_variable(pos_x, value)
        @variable[pos_x] = (Random.rand(0xFF) & value)
      end

      def new_display_data(register_x, register_y, n_pixels_tall, memory, display_buffer)
        @variable[0xF] = 0

        (0..(n_pixels_tall - 1)).each do |row|
          var_y = @variable[register_y] % Display::HEIGHT + row
          sprite_memory_address = @index + row
          sprite = memory.access(sprite_memory_address)

          # @type break: (::Range[::Integer] | ::Integer | nil)
          break if var_y.nil? || var_y > Display::HEIGHT - 1 # To stop drawing when leaving the screen

          draw_sprite_on_display_buffer(display_buffer, var_y, register_x, sprite)
        end
        display_buffer
      end

      # rubocop:disable Metrics/AbcSize
      def draw_sprite_on_display_buffer(display_buffer, var_y, register_x, sprite)
        (0..7).each do |pixel_position|
          var_x = @variable[register_x] % Display::WIDTH + pixel_position

          # @type break: (::Range[::Integer] | ::Integer | nil)
          break if var_x.nil? || var_x > Display::WIDTH - 1 # To stop drawing when leaving the screen

          # the way we output in the screen is from the high bit to the low bit
          memory_pixel = (sprite & (1 << (7 - pixel_position))).positive? ? 1 : 0
          # memory_pixel = sprite.to_s(2).rjust(8, '0')[pixel_position].to_i # slower method

          screen_pixel = display_buffer[var_x, var_y] #  & 0x1

          display_buffer[var_x, var_y] = memory_pixel ^ screen_pixel

          @variable[0xF] = if memory_pixel.positive? && screen_pixel.positive?
                             0x01
                           else
                             @variable[0xF]
                           end
        end
      end

      # rubocop:enable Metrics/AbcSize

      private

      def validate_position_ranges(pos_x, pos_y)
        raise ArgumentError, "Invalid Variable Position X: #{pos_x}" if pos_x > 0xF # 15
        raise ArgumentError, "Invalid Variable Position Y: #{pos_y}" if pos_y > 0xF # 15
      end
    end
  end
end
