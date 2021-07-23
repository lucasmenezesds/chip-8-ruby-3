module Chip8
  module Components
    class Clock
      # FREQUENCY = 3600 # 60 times * 60 seconds

      attr_reader :delay_timer, :sound_timer, :cpu_clock

      def initialize
        @clock_hz = 60
        @cpu_clock = 1.0 / @clock_hz # 60 #6megahertz  hz it's  the opposite of seconds
        @delay_timer = 0xFF
        @sound_timer = 0xFF
      end

      def update
        update_delay_timer
        update_sound_timer
      end

      def set_delay_timer(new_value)
        raise ArgumentError, "Invalid New Value: #{new_value}" if new_value > 0xFF # 255

        @delay_timer = new_value
      end

      def set_sound_timer(new_value)
        raise ArgumentError, "Invalid New Value: #{new_value}" if new_value > 0xFF # 255

        @sound_timer = new_value
      end

      def update_delay_timer
        @delay_timer -= 1 if @delay_timer.positive?
      end

      def update_sound_timer
        @sound_timer -= 1 if @sound_timer.positive?
      end

      def increase_cpu_clock
        @clock_hz += 20
        puts "++ INCREASED CPU Clock to #{@clock_hz}Hz ++"
        @cpu_clock = 1.0 / @clock_hz
      end

      def decrease_cpu_clock
        if @clock_hz > 20
          @clock_hz -= 20
          puts "-- DECREASED CPU Clock to #{@clock_hz}Hz --"
          @cpu_clock = 1.0 / @clock_hz
        end
      end

      def reset_cpu_clock
        @clock_hz = 60
        puts "** CPU Clock RESET to #{@clock_hz}Hz **"
        @cpu_clock = 1.0 / @clock_hz
      end
    end
  end
end
