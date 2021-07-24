# frozen_string_literal: true

describe Chip8::Components::Register do
  subject { described_class.new }

  context "#new_index" do
    it "should set the Index Register to the expected value" do
      subject.set_index(0x10)

      expect(subject.index).to eq 0x10
    end

    it "should raise an argument error if tried set the Index Register bigger than 0xFFF" do
      expect { subject.set_index(0xFFF1) }.to raise_error(ArgumentError)
    end
  end

  context "#set_variable_in_position" do
    it "should set the variable to the expected value at the expected position" do
      subject.set_variable_in_position(0xF, 0x6)

      variable_data = subject.instance_variable_get(:@variable)
      expect(variable_data[0xF]).to eq 0x6
    end

    it "should raise an argument error if variable_pos > 0xF" do
      expect { subject.set_variable_in_position(0x10, 0x1) }.to raise_error(ArgumentError)
    end

    it "should raise an argument error if new_value > 0xFF " do
      expect { subject.set_variable_in_position(0xF, 0x100) }.to raise_error(ArgumentError)
    end
  end

  context "#add_to_variable" do
    it "should add(sum) the received value in the received position" do
      subject.add_to_variable(0xA, 0x10)
      subject.add_to_variable(0xA, 0xFF) # checking the % to the overflow

      variable_data = subject.instance_variable_get(:@variable)[0xA]
      expect(variable_data).to eq 0xF
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

      current_index = subject.index
      current_vf = subject.instance_variable_get(:@variable)[0xF]
      expect(current_index).to eq 0
      expect(current_index.class).to eq Integer
      expect(current_vf.class).to eq Integer
      expect(result).not_to eq Matrix.zero(32, 64)
    end
  end
  context "#subtract_variables" do
    # VX = VX - VY
    it "should subtract VY from VX and store on VX" do
      subject.set_variable_in_position(0x1, 0x10) # VX
      subject.set_variable_in_position(0x3, 0xF) # VY

      variable_data = subject.instance_variable_get(:@variable)

      subject.subtract_variables(0x1, 0x3, var_destination: 0x1)

      expect(variable_data[0x1]).to eq 0x1
      expect(variable_data[0xF]).to eq 0x1
    end

    it "should subtract VX from VY and store on VX" do
      subject.set_variable_in_position(0x1, 0xF) # VX
      subject.set_variable_in_position(0x3, 0xA) # VY

      variable_data = subject.instance_variable_get(:@variable)

      subject.subtract_variables(0x3, 0x1, var_destination: 0x1)

      expect(variable_data[0x1]).to eq 0xFB
      expect(variable_data[0xF]).to eq 0x0
    end
  end
end
