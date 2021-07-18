# frozen_string_literal: true

module Chip8
  module Components
    # CPU Status
    class CPUStatus
      attr_reader :stopped

      def initialize
        @stopped = false
      end

      def stop_it
        @stopped = true
        sleep 0.1
        puts "Stopped the CPU!"
      end
    end
  end
end
