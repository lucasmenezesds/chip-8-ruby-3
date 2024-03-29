# frozen_string_literal: true

module Chip8
  module Components
    # Chip8 Keyboard
    class Keyboard
      KEYBOARD_POSITIONS = {
        Gosu::KB_1 => 0x1,
        Gosu::KB_2 => 0x2,
        Gosu::KB_3 => 0x3,
        Gosu::KB_4 => 0xC,
        Gosu::KB_Q => 0x4,
        Gosu::KB_W => 0x5,
        Gosu::KB_E => 0x6,
        Gosu::KB_R => 0xD,
        Gosu::KB_A => 0x7,
        Gosu::KB_S => 0x8,
        Gosu::KB_D => 0x9,
        Gosu::KB_F => 0xE,
        Gosu::KB_Z => 0xA,
        Gosu::KB_X => 0x0,
        Gosu::KB_C => 0xB,
        Gosu::KB_V => 0xF
      }.freeze

      attr_reader :keyboard_register

      def initialize
        @keyboard_register = Array.new(0x10, 0x0)
      end

      def press_key(key_id)
        pos = KEYBOARD_POSITIONS.fetch(key_id, nil)
        @keyboard_register[pos] = 1 if pos
      end

      def release_key(key_id)
        pos = KEYBOARD_POSITIONS.fetch(key_id, nil)
        @keyboard_register[pos] = 0 if pos
      end

      def key_pressed?(key_position)
        @keyboard_register[key_position]&.positive? || false
      end

      def key_value(key_id)
        KEYBOARD_POSITIONS.fetch(key_id, 0)
      end

      def position_of_key_pressed
        @keyboard_register.find_index(1)
      end
    end
  end
end
