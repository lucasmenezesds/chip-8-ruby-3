# frozen_string_literal: true

module Chip8
  module Components
    # Also commonly known as 'PC'
    class ProgramCounter
      attr_reader :index

      def initialize(starting_index:)
        @starting_index = starting_index
        @index = starting_index
      end

      def increment_index_position
        if @index <= 0xFFD # 4094
          @index += 0x2
        else
          @index = @starting_index
        end
      end

      def decrement_index_position
        if @index == @starting_index
          @index = 0xFFF # 4095
        else
          @index -= 0x2
        end
      end

      def update_index(new_index, offset: 0)
        final_position = new_index + offset
        raise ArgumentError, "Invalid Position: #{final_position}" if final_position > 0xFFF # 4095

        @index = final_position
      end
    end
  end
end
