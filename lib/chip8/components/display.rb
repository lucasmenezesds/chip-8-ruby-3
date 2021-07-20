# frozen_string_literal: true

require "gosu"
require "matrix"

module Chip8
  module Components
    # Chip-8s Display
    class Display < Gosu::Window
      WIDTH = 64
      HEIGHT = 32
      SCALE = 10

      WHITE = Gosu::Color::WHITE
      BLACK = Gosu::Color::BLACK

      attr_reader :display_buffer

      def initialize(halt_option, keyboard)
        super (WIDTH * SCALE), (HEIGHT * SCALE)
        self.caption = "CHIP-8 Display"
        @display_buffer = Matrix.zero(WIDTH, HEIGHT)
        @halt_option = halt_option
        @keyboard = keyboard
      end

      def update; end

      def draw
        (0..(WIDTH - 1)).each do |width|
          (0..(HEIGHT - 1)).each do |height|
            value = @display_buffer[width, height]

            next unless value.positive?

            draw_rect(width * SCALE, height * SCALE, SCALE, SCALE, WHITE, 0, :default)
          end
        end
      end

      def update_display_buffer(new_display_matrix)
        @display_buffer = new_display_matrix
      end

      def clean_display
        update_display_buffer(Matrix.zero(WIDTH, HEIGHT))
      end

      def button_down(id)
        case id
        when Gosu::KB_ESCAPE
          @halt_option.stop_it
          puts "== Bye Bye! =="
        else
          @keyboard.key_pressed(id)
        end
      end

      def button_up(id)
        case id
        when Gosu::KB_ESCAPE
          close
        else
          @keyboard.key_released(id)
        end
      end
    end
  end
end
