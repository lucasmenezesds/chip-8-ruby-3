# frozen_string_literal: true

describe Chip8::Interpreter do
  before do
    fonts_mock = [
      0xF0, 0x90, 0x90, 0x90, 0xF0 # 0
    ].freeze

    memory_module = "Chip8::Components::Memory"
    fonts_module = "Chip8::Components::Fonts"

    stub_const("#{memory_module}::RAM_STARTING_ADDRESS", 0x0)
    stub_const("#{memory_module}::RAM_ENDING_ADDRESS", 0x8)
    stub_const("#{memory_module}::PROGRAMS_STARTING_ADDRESS", 0x9)
    stub_const("#{memory_module}::TOTAL_MEMORY_SIZE", 0x10)
    stub_const("#{fonts_module}::FONTS", fonts_mock)
    stub_const("#{memory_module}::FONT_STARTING_ADDRESS", 0x1)
    stub_const("#{memory_module}::FONT_ENDING_ADDRESS", 0x7)
  end

  context "#cpu_cycle" do
    subject { Chip8::Interpreter.new }

    it "should call the expected methods only once" do
      expect(subject).to receive(:fetch).once
      expect(subject).to receive(:decode).once
      expect(subject).to receive(:execute).once

      subject.cpu_cycle
    end

    it "should run a cpu_cycle without breaking" do
      allow(Chip8::Components::ProgramCounter).to receive(:index).and_return(1)
      allow_any_instance_of(Chip8::Components::Memory).to receive(:access).with(0x9).and_return(0x00)
      allow_any_instance_of(Chip8::Components::Memory).to receive(:access).with(0xA).and_return(0x0E)
      allow(Chip8::Components::ProgramCounter).to receive(:increment_index_position)
      expect(Chip8::Components::Instructions).to receive(:run).once

      subject.cpu_cycle

      expected_nibble = { "instruction" => 0, "n" => 14, "nn" => 14, "nnn" => 14, "x" => 0, "y" => 0 }

      expect(subject.instance_variable_get(:@opcode)).to eq(0xE)
      expect(subject.instance_variable_get(:@nibbles)).to eq(expected_nibble)
    end
  end

  context "#run" do
    subject { Chip8::Interpreter.new }

    it "should call the expected methods only once" do
      expect(subject).to receive(:fetch).once
      expect(subject).to receive(:decode).once
      expect(subject).to receive(:execute).once

      # stopping before running the loop
      subject.instance_variable_get(:@cpu_status).stop_it

      subject.run
    end
  end

  context "#show_display" do
    subject { Chip8::Interpreter.new }

    it "should call #show from display class" do
      allow_any_instance_of(Chip8::Components::Display).to receive(:show).and_return(true)

      expect(subject.show_display).to be_truthy
    end
  end

  context "#load_rom" do
    subject { Chip8::Interpreter.new }

    it "should call #load_rom from memory class" do
      allow_any_instance_of(Chip8::Components::Memory).to receive(:load_rom).with("xx").and_return(true)

      expect(subject.load_rom("xx")).to be_truthy
    end
  end
end
