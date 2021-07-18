# frozen_string_literal: true

describe Chip8::Components::ProgramCounter do
  context "#increment_index_position" do
    subject { described_class.new(starting_index: 0xFFD) }
    it "should increment @index by 2" do
      subject.increment_index_position

      expect(subject.index).to eq 0xFFF
    end

    it "should set @index to the starting_index if the current index is > 0xFFD" do
      subject.increment_index_position
      subject.increment_index_position

      expect(subject.index).to eq 0xFFD
    end
  end

  context "#new_position" do
    subject { described_class.new(starting_index: 0xFFD) }
    it "should set the index to the expected value" do
      subject.new_position(0x10)

      expect(subject.index).to eq 0x10
    end

    it "should raise an argument error if tried set a index bigger than 0xFFF" do
      expect { subject.new_position(0xFFFF) }.to raise_error(ArgumentError)
    end
  end
end