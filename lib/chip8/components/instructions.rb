# frozen_string_literal: true

require_relative "../helpers/debug"
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/ModuleLength
# rubocop:disable Metrics/ParameterLists
module Chip8
  module Components
    # Chip-8's Instructions
    module Instructions
      def self.run(nibbles, display:, keyboard:, memory:, program_counter:, register:, stack:, clock:)
        case nibbles["instruction"]
        when 0x0
          case nibbles["nnn"]
          when 0x0EE # 00EE OK
            instruction_00ee(nibbles, program_counter, stack)
          when 0x0E0 # 00E0 CHECKED
            instruction_00e0(display, nibbles, program_counter)
          else
            puts "Implementation not needed" # 0NNN: Execute machine language routine
          end
        when 0x1 # 1NNN OK
          instruction_1nnn(nibbles, program_counter)
        when 0x2 # 2NNN ~checked
          instruction_2nnn(nibbles, program_counter, stack)
        when 0x3 # 3XNN OK
          instruction_3xnn(nibbles, program_counter, register)
        when 0x4 # 4XNN OK
          instruction_4xnn(nibbles, program_counter, register)
        when 0x5 # 5XY0 OK
          instruction_5xy0(nibbles, program_counter, register)
        when 0x6 # 6XNN OK
          instruction_6xnn(nibbles, program_counter, register)
        when 0x7 # 7XNN OK
          instruction_7xnn(nibbles, program_counter, register)
        when 0x8
          arithmetical_methods(nibbles, register, display, program_counter)
        when 0x9 # 9XY0 OK
          instruction_9xy0(nibbles, program_counter, register)
        when 0xA
          instruction_annn(nibbles, program_counter, register)
        when 0xB
          instruction_bnnn(nibbles, program_counter, register)
        when 0xC
          instruction_cxnn(nibbles, program_counter, register)
        when 0xD
          instruction_dxyn(display, memory, nibbles, program_counter, register)
        when 0xE
          case nibbles["nn"]
          when 0x9E
            instruction_ex9e(keyboard, nibbles, program_counter, register)
          when 0xA1
            instruction_exa1(keyboard, nibbles, program_counter, register)
          else
            puts "some strange instruction... 1nibble['nn']"
          end
        when 0xF
          case nibbles["nn"]
          when 0x07
            instruction_fx07(clock, nibbles, program_counter, register)
          when 0x0A # CHECKED
            instruction_fx0a(keyboard, nibbles, program_counter, register)
          when 0x15
            instruction_fx15(clock, nibbles, program_counter, register)
          when 0x18
            instruction_fx18(clock, nibbles, program_counter, register)
          when 0x1E
            instruction_fx1e(nibbles, program_counter, register)
          when 0x29
            instruction_fx29(nibbles, program_counter, register)
          when 0x33 # FX33 OK
            instruction_fx33(memory, nibbles, program_counter, register)
          when 0x55 # FX55 OK
            instruction_fx55(memory, nibbles, program_counter, register)
          when 0x65
            instruction_fx65(memory, nibbles, program_counter, register)
          else
            puts "some strange instruction... 2nibble['nn'] #{nibbles.inspect}"
          end
        else
          puts "do nothing (for now)"
        end
      end

      # Fourth nibbles Operations
      def self.arithmetical_methods(nibbles, register, _display, program_counter)
        case nibbles["n"] # Nibble 4
        when 0x0 # 0x8XY0 OK
          Chip8::Helpers::Debug.debug("8XY0", "(set register VX from VY)", nibbles, program_counter: program_counter)
          register.copy_variable_data_from_to(nibbles["y"], nibbles["x"])

        when 0x1 # 0x8XY1 OK
          Chip8::Helpers::Debug.debug("8XY1", "(Bitwise Logical OR)", nibbles, program_counter: program_counter)
          register.bitwise_logical_or(nibbles["x"], nibbles["y"])

        when 0x2 # 0x8XY2 OK
          Chip8::Helpers::Debug.debug("8XY2", "(Logical AND)", nibbles, program_counter: program_counter)
          register.bitwise_logical_and(nibbles["x"], nibbles["y"])

        when 0x3 # 0x8XY3 OK
          Chip8::Helpers::Debug.debug("8XY3", "(Logical XOR)", nibbles, program_counter: program_counter)
          register.bitwise_logical_xor(nibbles["x"], nibbles["y"])

        when 0x4 # 0x8XY4 OK
          Chip8::Helpers::Debug.debug("8XY4", "(ADD => VX = VX+VY)", nibbles, program_counter: program_counter)
          register.sum_variable_from_into(nibbles["y"], nibbles["x"])

        when 0x5 # 0x8XY5 OK
          Chip8::Helpers::Debug.debug("8XY5", "(SUBTRACT => VX = VX-VY)", nibbles, program_counter: program_counter)
          register.subtract_variables(nibbles["x"], nibbles["y"], var_destination: nibbles["x"])

        when 0x6 # 0x8XY6 OK
          Chip8::Helpers::Debug.debug("8XY6", "(VY Shifting to RIGHT (becomes VX))", nibbles,
                                      program_counter: program_counter)
          register.bitwise_logical_shift(nibbles["x"], nibbles["y"], to_right: true)

        when 0x7 # 8XY7 OK
          Chip8::Helpers::Debug.debug("8XY7", "(SUBTRACT => VX = VY - VX)", nibbles, program_counter: program_counter)
          register.subtract_variables(nibbles["y"], nibbles["x"], var_destination: nibbles["x"])

        when 0xE # 0x8XYE OK
          Chip8::Helpers::Debug.debug("8XYE", "(VY Shifting to LEFT (becomes VX))", nibbles,
                                      program_counter: program_counter)
          register.bitwise_logical_shift(nibbles["x"], nibbles["y"], to_right: false)
        else
          puts "some strange instruction..."
        end
      end

      def self.instruction_00e0(display, nibbles, program_counter)
        Chip8::Helpers::Debug.debug("00E0", "clear screen", nibbles, program_counter: program_counter)
        display.clean_display
      end

      def self.instruction_00ee(nibbles, program_counter, stack)
        Chip8::Helpers::Debug.debug("00EE", "(00EE 'popping' Subroutines)", nibbles, program_counter: program_counter)
        popped_data = stack.pop_data
        program_counter.new_position(popped_data)
      end

      def self.instruction_1nnn(nibbles, program_counter)
        Chip8::Helpers::Debug.debug("1NNN", "(jump)", nibbles["nnn"].to_s(16), program_counter: program_counter)
        program_counter.new_position(nibbles["nnn"])
      end

      def self.instruction_2nnn(nibbles, program_counter, stack)
        Chip8::Helpers::Debug.debug("2NNN", "(2NNN 'pushing' Subroutines)", nibbles["nnn"].to_s(16),
                                    program_counter: program_counter)
        stack.push_data(program_counter.index)
        program_counter.new_position(nibbles["nnn"])
      end

      def self.instruction_3xnn(nibbles, program_counter, register)
        Chip8::Helpers::Debug.debug("3XNN", "(VX == NN => Skip)", nibbles, program_counter: program_counter)
        variable_value = register.get_variable_in_position(nibbles["x"])
        program_counter.increment_index_position if variable_value == nibbles["nn"]
      end

      def self.instruction_4xnn(nibbles, program_counter, register)
        Chip8::Helpers::Debug.debug("4XNN", "(X != NN => Skip)", nibbles, program_counter: program_counter)
        variable_value = register.get_variable_in_position(nibbles["x"])
        program_counter.increment_index_position if variable_value != nibbles["nn"]
      end

      def self.instruction_5xy0(nibbles, program_counter, register)
        Chip8::Helpers::Debug.debug("5XY0", "(vX == vY => Skip)", nibbles, program_counter: program_counter)
        variable_x_value = register.get_variable_in_position(nibbles["x"])
        variable_y_value = register.get_variable_in_position(nibbles["y"])
        program_counter.increment_index_position if variable_x_value == variable_y_value
      end

      def self.instruction_7xnn(nibbles, program_counter, register)
        Chip8::Helpers::Debug.debug("7XNN", "(add value to register VX)", nibbles, program_counter: program_counter)
        register.add_to_variable(nibbles["x"], nibbles["nn"])
      end

      def self.instruction_9xy0(nibbles, program_counter, register)
        Chip8::Helpers::Debug.debug("9XY0", "(Vx != Vy => SKIP)", nibbles, program_counter: program_counter)
        variable_x_value = register.get_variable_in_position(nibbles["x"])
        variable_y_value = register.get_variable_in_position(nibbles["y"])
        program_counter.increment_index_position if variable_x_value != variable_y_value
      end

      def self.instruction_annn(nibbles, program_counter, register)
        Chip8::Helpers::Debug.debug("ANNN", "(set index register I)", nibbles, program_counter: program_counter)
        register.set_index(nibbles["nnn"])
      end

      def self.instruction_exa1(keyboard, nibbles, program_counter, register)
        Chip8::Helpers::Debug.debug("EXA1", "(SKIP if Key NOT Pressed)", nibbles, program_counter: program_counter,
                                                                                  force_debug: false)
        value_register_x = register.get_variable_in_position(nibbles["x"])
        program_counter.increment_index_position if keyboard.key_pressed?(value_register_x) == false
      end

      def self.instruction_ex9e(keyboard, nibbles, program_counter, register)
        Chip8::Helpers::Debug.debug("EX9E", "(SKIP if Key Pressed)", nibbles, program_counter: program_counter,
                                                                              force_debug: false)
        value_register_x = register.get_variable_in_position(nibbles["x"])
        program_counter.increment_index_position if keyboard.key_pressed?(value_register_x)
      end

      def self.instruction_dxyn(display, memory, nibbles, program_counter, register)
        Chip8::Helpers::Debug.debug("DXYN", "(display/draw)", nibbles, program_counter: program_counter)
        new_display_data = register.new_display_data(nibbles["x"], nibbles["y"], nibbles["n"], memory,
                                                     display.display_buffer)
        display.update_display_buffer(new_display_data)
      end

      def self.instruction_cxnn(nibbles, program_counter, register)
        Chip8::Helpers::Debug.debug("CXNN", "(CXNN: Random)", nibbles, program_counter: program_counter)
        register.set_random_value_into_variable(nibbles["x"], nibbles["nn"])
      end

      def self.instruction_bnnn(nibbles, program_counter, register)
        # Add the second "jump" instruction later [Other Chip-8 implementation]
        Chip8::Helpers::Debug.debug("BNNN", "(set index register I[Jump with offset])", nibbles,
                                    program_counter: program_counter)
        program_counter.new_position(nibbles["nnn"], offset: register.get_variable_in_position(0x0))
      end

      def self.instruction_6xnn(nibbles, program_counter, register)
        Chip8::Helpers::Debug.debug("6XNN", "(set register VX)", nibbles["nn"].to_s(16),
                                    program_counter: program_counter)
        register.set_variable_in_position(nibbles["x"], nibbles["nn"])
      end

      def self.instruction_fx07(clock, nibbles, program_counter, register)
        Chip8::Helpers::Debug.debug("FX07", "VX = delay timer value", nibbles, program_counter: program_counter)
        register.set_variable_in_position(nibbles["x"], clock.delay_timer)
      end

      def self.instruction_fx0a(keyboard, nibbles, program_counter, register)
        Chip8::Helpers::Debug.debug("FX0A", "Get key pressed", nibbles, program_counter: program_counter)
        key_pressed_pos = keyboard.position_of_key_pressed
        if key_pressed_pos.nil?
          program_counter.decrement_index_position
        else
          register.set_variable_in_position(nibbles["x"], key_pressed_pos)
        end
      end

      def self.instruction_fx15(clock, nibbles, program_counter, register)
        Chip8::Helpers::Debug.debug("FX15", "Sets delay timer = VX value", nibbles, program_counter: program_counter)
        variable_x_value = register.get_variable_in_position(nibbles["x"])
        clock.set_delay_timer(variable_x_value)
      end

      def self.instruction_fx18(clock, nibbles, program_counter, register)
        Chip8::Helpers::Debug.debug("FX18", "Sets sound timer = VX Value", nibbles, program_counter: program_counter)
        variable_x_value = register.get_variable_in_position(nibbles["x"])
        clock.set_sound_timer(variable_x_value)
      end

      def self.instruction_fx1e(nibbles, program_counter, register)
        Chip8::Helpers::Debug.debug("FX1E", "Add to index", nibbles, program_counter: program_counter)
        variable_x_value = register.get_variable_in_position(nibbles["x"])
        current_register_index = register.index
        final_index = variable_x_value + current_register_index
        register.set_index(final_index)
      end

      def self.instruction_fx29(nibbles, program_counter, register)
        Chip8::Helpers::Debug.debug("FX29", "Font character", nibbles, program_counter: program_counter)
        font_index = Fonts::FONT_STARTING_ADDRESS
        variable_x_value = (register.get_variable_in_position(nibbles["x"]) & 0xF) * 5
        final_value = font_index + variable_x_value
        register.set_index(final_value)
      end

      def self.instruction_fx33(memory, nibbles, program_counter, register)
        Chip8::Helpers::Debug.debug("FX33", "Binary-coded decimal conversion", nibbles,
                                    program_counter: program_counter)
        convert_binary_coded_into_decimal_digits(nibbles, memory, register)
      end

      def self.instruction_fx55(memory, nibbles, program_counter, register)
        Chip8::Helpers::Debug.debug("FX55", "", nibbles, program_counter: program_counter)
        # Modern
        x_value = nibbles["x"]
        (0x0..x_value).each do |pos|
          memory_position = register.index + pos
          register_data = register.get_variable_in_position(pos)
          memory.update_value(memory_position, register_data)
        end
      end

      def self.instruction_fx65(memory, nibbles, program_counter, register)
        Chip8::Helpers::Debug.debug("FX65", "", nibbles, program_counter: program_counter, force_debug: false)
        # Modern
        x_value = nibbles["x"]
        (0x0..x_value).each do |pos|
          memory_position = register.index + pos
          memory_data = memory.access(memory_position)
          register.set_variable_in_position(pos, memory_data)
        end
      end

      def self.convert_binary_coded_into_decimal_digits(nibbles, memory, register)
        register_index = register.index
        register_value = register.get_variable_in_position(nibbles["x"])

        hundredth_val = register_value / 100
        decimal_val = (register_value - (hundredth_val * 100)) / 10
        unit_val = (register_value - ((hundredth_val * 100) + (decimal_val * 10)))

        memory.update_value(register_index, hundredth_val)
        memory.update_value(register_index + 1, decimal_val)
        memory.update_value(register_index + 2, unit_val)
      end
    end
  end
end

# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/ModuleLength
# rubocop:enable Metrics/ParameterLists
