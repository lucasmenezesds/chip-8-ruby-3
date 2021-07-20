# frozen_string_literal: true

module Chip8
  module Components
    # Chip-8s Stack representation
    class Stack
      def initialize
        @data = [] # 16-bit addresses
      end

      def push_data(data)
        @data << data
      end

      def pop_data
        @data.pop
      end
    end
  end
end
