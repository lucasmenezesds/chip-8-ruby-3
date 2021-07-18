# frozen_string_literal: true

require_relative "../../../../lib/chip8/components/fonts"

MOCK_PROGRAMS_STARTING_ADDRESS = 0x9

describe Chip8::Components::Memory do
  before do
    fonts_mock = [
      0xF0, 0x90, 0x90, 0x90, 0xF0 # 0
    ].freeze

    memory_module = "Chip8::Components::Memory"
    fonts_module = "Chip8::Components::Fonts"

    stub_const("#{memory_module}::RAM_STARTING_ADDRESS", 0x0)
    stub_const("#{memory_module}::RAM_ENDING_ADDRESS", 0x8)
    stub_const("#{memory_module}::PROGRAMS_STARTING_ADDRESS", MOCK_PROGRAMS_STARTING_ADDRESS)
    stub_const("#{memory_module}::TOTAL_MEMORY_SIZE", 0x10)
    stub_const("#{fonts_module}::FONTS", fonts_mock)
    stub_const("#{memory_module}::FONT_STARTING_ADDRESS", 0x1)
    stub_const("#{memory_module}::FONT_ENDING_ADDRESS", 0x7)
  end

  context "#initialize" do
    subject { described_class.new }
    it "should have all addresses set as 0" do
      memory_data = subject.memory
      uniq_data = memory_data.uniq

      expect(uniq_data.size).to eq 1
      expect(uniq_data[0]).to eq 0
    end
  end
  context "#update_value" do
    it "should be able to update a value in a specific position" do
      before_update_value = subject.access(0xA)
      subject.update_value(0xA, 0xC)
      after_update_value = subject.access(0xA)

      expect(before_update_value).not_to eq after_update_value
    end
  end

  context "#load_fonts_into_memory" do
    it "should include some expected hexadecimal values after the fonts are loaded" do
      before = subject.memory
      before_uniq_data = before.uniq

      subject.load_fonts_into_memory

      current_memory = subject.memory
      after_uniq_data = current_memory.uniq

      expect(before_uniq_data.size).to eq 1
      expect(after_uniq_data.size).to eq 3
      expect(after_uniq_data).to match([0x0, 0xF0, 0x90])
    end
  end

  context "#access" do
    subject { described_class.new }
    before do
      subject.load_fonts_into_memory
      subject.update_value(0x9, 0xAF)
      subject.update_value(0xF, 0xF)
    end

    it "should return the PROGRAMS_STARTING_ADDRESS data when accessing an invalid address" do
      data = subject.access(999)

      expect(data).to eq 0xAF
    end

    it "should return the last data stored in the memory" do
      last_pos = 0x10 - 1
      data = subject.access(last_pos)

      expect(data).to eq 0xF
    end
  end

  context "#load_fonts_into_memory" do
    it "should load a rom(bytecodes) into the memory" do
      before = subject.memory
      before_uniq_data = before.uniq

      # "11111111", "11111110", "11111101", "11111100"
      bytecodes = [0xFF, 0xFE, 0xFD, 0xFC]
      subject.load_rom(bytecodes)

      current_memory = subject.memory
      after_uniq_data = current_memory.uniq

      sliced_array = current_memory[MOCK_PROGRAMS_STARTING_ADDRESS..MOCK_PROGRAMS_STARTING_ADDRESS + 3]

      expect(before_uniq_data.size).to eq 1
      expect(after_uniq_data.size).to eq 5

      expect(sliced_array).to match(bytecodes)
    end
  end

  context "#clean" do
    it "should set all memory array as 0x0" do
      bytecodes = [0xFF, 0xFE, 0xFD, 0xFC]
      subject.load_rom(bytecodes)

      subject.clean
      current_memory = subject.memory
      after_uniq_data = current_memory.uniq

      expect(after_uniq_data.size).to eq 1
      expect(after_uniq_data[0]).to eq 0
    end
  end
end
