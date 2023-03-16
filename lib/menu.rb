# frozen_string_literal: true

require_relative "menu/components"
require_relative "menu/version"

# Menu's module
module Menu
  # Menu Class xD
  class Menu
    attr_accessor :selected_rom

    def initialize(debug_flag: nil, rom_name: nil)
      @debug_flag = debug_flag
      @rom_name = rom_name

      define_flow
    end

    private

    def define_flow
      if @debug_flag.nil?
        @selected_rom = show_roms
      else
        set_debug_flags
        valid_rom_name?
        @selected_rom = @rom_name
      end
    end

    def valid_rom_name?
      return true unless @rom_name.nil? || %w[.o .ch8].none? { |file_ext| @rom_name.include?(file_ext) }

      abort("== Please tell me which rom you want to play! ==")
    end

    # rubocop:disable Style/GlobalVars
    def set_debug_flags
      $STEP_BY_STEP_FLAG = false
      $DEBUG_FLAG = @debug_flag.to_i == 1
    end

    # rubocop:enable Style/GlobalVars

    def list_roms
      Dir.entries("roms/").reject do |entry|
        file_ext = File.extname(entry)
        file_ext != ".o" && file_ext != ".ch8"
      end
    end

    def show_roms
      list_of_roms = list_roms
      @prompt = Components::Prompt.new(rom_list: list_of_roms)
      @prompt.build_prompt
    end
  end
end
