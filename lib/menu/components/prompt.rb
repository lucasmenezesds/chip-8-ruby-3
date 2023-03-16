# frozen_string_literal: true

require "tty-prompt"

# Menu's module
module Menu
  module Components
    # Prompt Class
    class Prompt
      def initialize(rom_list:)
        @prompt = TTY::Prompt.new(help_color: :cyan)
        @rom_list = rom_list
      end

      def build_prompt
        abort("== Please put some roms in the roms folder and try again ==") if @rom_list.empty?

        @prompt.select("Select the rom you want to load", @rom_list)
      end
    end
  end
end
