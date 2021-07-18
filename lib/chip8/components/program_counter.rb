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

      def new_position(new_position)
        raise ArgumentError, "Invalid Position: #{new_position}" if new_position > 0xFFF # 4095

        @index = new_position
      end
    end
  end
end
