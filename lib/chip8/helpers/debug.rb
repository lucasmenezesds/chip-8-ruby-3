# frozen_string_literal: true

require "io/console"

# rubocop:disable Style/GlobalStdStream
# rubocop:disable Style/GlobalVars

module Chip8
  module Helpers
    module Debug
      def self.debug(opcode, command_action, nibble, program_counter: nil, full_nibble: nil, force_debug: false)
        return unless $DEBUG_FLAG || force_debug

        # Thread.new do
        toggle_step_by_step
        puts "=="
        puts "DEBUG: MEM POS => ##{program_counter.index.inspect}" unless program_counter.nil?
        puts "DEBUG: OPCODE = #{opcode.inspect}"
        puts "DEBUG: command_action = #{command_action.inspect}"
        puts "DEBUG: FULL nibble= #{transform_nibble(nibble).inspect}"
        puts "=="
        # end
      end

      def self.transform_nibble(nibble)
        nibble.each_with_object({}) { |(k, v), h| h[k] = v&.to_s(16); } if nibble.is_a?(Hash)
      end

      def self.toggle_step_by_step
        STDIN.getch if $STEP_BY_STEP_FLAG # TODO: change it to manage it on the display.
      end
    end
  end
end

# rubocop:enable Style/GlobalStdStream
# rubocop:enable Style/GlobalVars
