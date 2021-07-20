# frozen_string_literal: true

module Chip8
  module Components
    # Chip-8's Instructions

    # rubocop:disable Metrics/ModuleLength
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    module Instructions
      def self.run(nibble, display:, keyboard:, memory:, program_counter:, register:, stack:)
        case nibble["instruction"]
        when 0x0
          debug("00E0", "clear screen", nibble, program_counter: program_counter)
          display.clean_display # set_display_info

        when 0x1
          debug("1NNN", "(jump)", nibble["nnn"].to_s(16), program_counter: program_counter)
          program_counter.new_position(nibble["nnn"])

        when 0x6
          debug("6XNN", "(set register VX)", nibble["nn"].to_s(16), program_counter: program_counter,
                                                                    full_nibble: nibble)
          register.set_variable(nibble["x"], nibble["nn"])

        when 0x7
          debug("7XNN", "(add value to register VX)", nibble, program_counter: program_counter)
          register.add_to_variable(nibble["x"], nibble["nn"])

        when 0xA
          debug("ANNN", "(set index register I)", nibble, program_counter: program_counter)
          register.new_index(nibble["nnn"])

        when 0xD
          debug("DXYN", "(display/draw)", nibble, program_counter: program_counter)
          new_display_data = register.new_display_data(nibble["x"], nibble["y"], nibble["n"], memory,
                                                       display.display_buffer)
          display.update_display_buffer(new_display_data)
        else
          puts "do nothing (for now)"
        end
      end

      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength

      def self.debug(opcode, command_action, nibble, program_counter: nil, full_nibble: nil)
        # rubocop:disable Style/GlobalVars
        return unless $DEBUG_FLAG
        # rubocop:enable Style/GlobalVars

        puts "=="
        puts "DEBUG: MEM POS => ##{program_counter&.index.inspect}"
        puts "DEBUG: OPCODE = #{opcode}"
        puts "DEBUG: command_action = #{command_action}"
        puts "DEBUG: nibble = #{nibble.inspect}"
        puts "DEBUG: FULL nibble= #{full_nibble.inspect}" if full_nibble
        puts "=="
      end
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/ModuleLength
  end
end
