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

      def initialize(cpu_status:, keyboard:, clock:)
        super (WIDTH * SCALE), (HEIGHT * SCALE)
        self.caption = "CHIP-8 Display"
        @display_buffer = Matrix.zero(WIDTH, HEIGHT)
        @cpu_status = cpu_status
        @keyboard = keyboard
        @clock = clock
      end

      def update
        @clock.update_delay_timer
        @clock.update_sound_timer
      end

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
          @cpu_status.stop_it
          puts "== Bye Bye! =="
        when Gosu::KB_P
          $STEP_BY_STEP_FLAG = !$STEP_BY_STEP_FLAG

        when Gosu::KB_8
          @clock.decrease_cpu_clock
        when Gosu::KB_9
          @clock.increase_cpu_clock
        when Gosu::KB_0
          @clock.reset_cpu_clock
        else
          @keyboard.press_key(id)
        end
      end

      def button_up(id)
        case id
        when Gosu::KB_ESCAPE
          close
        else
          @keyboard.release_key(id)
        end
      end
    end
  end
end
