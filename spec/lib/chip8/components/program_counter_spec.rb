# frozen_string_literal: true

describe Chip8::Components::ProgramCounter do
  context "#update_index" do
    subject { described_class.new(starting_index: 0xFFD) }
    it "should set the index to the expected value" do
      subject.update_index(0x10)

      expect(subject.index).to eq 0x10
    end

    it "should raise an argument error if tried set a index bigger than 0xFFF" do
      expect { subject.update_index(0xFFFF) }.to raise_error(ArgumentError)
    end
  end

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

  context "#decrement_index_position" do
    subject { described_class.new(starting_index: 0x200) }
    it "should increment @index by 2" do
      expect(subject.index).to eq 0x200

      subject.decrement_index_position

      expect(subject.index).to eq 0xFFF
    end

    it "should set @index to the starting_index if the current index is > 0xFFD" do
      subject.decrement_index_position
      subject.decrement_index_position

      expect(subject.index).to eq 0xFFD
    end
  end
end
