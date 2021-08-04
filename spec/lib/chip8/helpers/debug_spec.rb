# frozen_string_literal: true

describe Chip8::Helpers::Debug do
  before do
    @program_counter_double = instance_double("Chip8::Components::ProgramCounter")
  end

  context "#debug" do
    it "should puts the debug when $DEBUG_FLAG is TRUE" do
      $DEBUG_FLAG = true
      nibble = { "instruction" => 0xFFFF, "x" => 0, "y" => 0,
                 "n" => nil, "nn" => nil, "nnn" => nil }
      allow(@program_counter_double).to receive_message_chain(:index, :inspect).and_return("")

      expect(described_class).to receive(:puts).exactly(6)

      described_class.debug(nibble["instruction"],
                            "test",
                            nibble,
                            program_counter: @program_counter_double)
    end

    it "should puts the debug when $DEBUG_FLAG is TRUE" do
      $DEBUG_FLAG = true
      nibble = { "instruction" => 0xFFFF, "x" => 0, "y" => 0,
                 "n" => nil, "nn" => nil, "nnn" => nil }

      expect(described_class).to receive(:puts).exactly(5)

      described_class.debug(nibble["instruction"],
                            "test",
                            nibble,
                            program_counter: nil)
    end

    it "should puts the debug when $DEBUG_FLAG is FALSE" do
      $DEBUG_FLAG = false
      nibble = { "instruction" => 0xFFFF, "x" => 0, "y" => 0,
                 "n" => nil, "nn" => nil, "nnn" => nil }

      expect(described_class).to receive(:puts).exactly(0)

      described_class.debug(nibble["instruction"],
                            "test",
                            nibble,
                            program_counter: @program_counter_double)
    end
  end
end
