# frozen_string_literal: true

describe Chip8::Components::Register do
  subject { described_class.new }

  context "#new_index" do
    it "should set the Index Register to the expected value" do
      subject.new_index(0x10)

      expect(subject.index).to eq 0x10
    end

    it "should raise an argument error if tried set the Index Register bigger than 0xFFF" do
      expect { subject.new_index(0xFFF1) }.to raise_error(ArgumentError)
    end
  end

  context "#set_variable" do
    it "should set the variable to the expected value at the expected position" do
      subject.set_variable(0xF, 0x1)

      variable_data = subject.instance_variable_get(:@variable)
      expect(variable_data[0xF]).to eq 0x1
    end

    it "should raise an argument error if variable_pos > 0xF" do
      expect { subject.set_variable(0x10, 0x1) }.to raise_error(ArgumentError)
    end

    it "should raise an argument error if new_value > 0xFF " do
      expect { subject.set_variable(0xF, 0x100) }.to raise_error(ArgumentError)
    end
  end

  context "#add_to_variable" do
    it "should add(sum) the received value in the received position" do
      subject.add_to_variable(0xF, 0x1)
      subject.add_to_variable(0xF, 0xFFF) # checking the % to the overflow

      variable_data = subject.instance_variable_get(:@variable)
      expect(variable_data[0xF]).to eq 0x10
    end

    it "should raise an argument error if variable_pos > 0xF" do
      expect { subject.add_to_variable(0x10, 0x1) }.to raise_error(ArgumentError)
    end
  end

  context "#new_display_data" do
    it "should return a Matrix with the new display_data" do
      display_buffer = Matrix.zero(32, 64)
      memory_double = instance_double("Chip8::Components::Memory")

      allow(memory_double).to receive(:access).and_return(0b10101010)

      result = subject.new_display_data(0x1, 0x2, 0x5, memory_double, display_buffer)

      expect(result).not_to eq Matrix.zero(32, 64)
    end
  end
end
