# frozen_string_literal: true

describe Chip8::Components::Register do
  subject { described_class.new }

  context "#update_index" do
    it "should set the Index Register to the expected value" do
      subject.update_index(0x10)

      expect(subject.index).to eq 0x10
    end

    it "should raise an argument error if tried set the Index Register bigger than 0xFFF" do
      expect { subject.update_index(0xFFF1) }.to raise_error(ArgumentError)
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

  context "#get_variable_in_position" do
    it "should return the expected value given the position" do
      subject.set_variable_in_position(0xD, 0xF)

      result = subject.get_variable_in_position(0xD)

      expect(result).to eq 0xF
    end

    it "should raise an argument error if variable_pos > 0xF" do
      expect { subject.get_variable_in_position(0x11) }.to raise_error(ArgumentError)
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

  context "#copy_variable_data_from_to" do
    it "should have the expected value in the received position" do
      vx_position = 0xC
      vy_position = 0x5
      subject.set_variable_in_position(vx_position, 0x1)
      subject.set_variable_in_position(vy_position, 0xA)

      subject.copy_variable_data_from_to(vy_position, vx_position)

      result = subject.instance_variable_get(:@variable)[vx_position]

      expect(result).to eq 0xA
    end
  end

  context "#bitwise_logical_or" do
    it "should have the expected value in VX, Vx = VX | VY" do
      vx_position = 0xC
      vy_position = 0x5
      subject.set_variable_in_position(vx_position, 0b10101010)
      subject.set_variable_in_position(vy_position, 0b10001111)

      subject.bitwise_logical_or(vx_position, vy_position)

      result = subject.instance_variable_get(:@variable)[vx_position]
      expect(result).to eq 0b10101111
    end
  end

  context "#bitwise_logical_and" do
    it "should have the expected value in VX, Vx = VX & VY" do
      vx_position = 0xC
      vy_position = 0x5
      subject.set_variable_in_position(vx_position, 0b10101010)
      subject.set_variable_in_position(vy_position, 0b10001111)

      subject.bitwise_logical_and(vx_position, vy_position)

      result = subject.instance_variable_get(:@variable)[vx_position]
      expect(result).to eq 0b10001010
    end
  end

  context "#bitwise_logical_xor" do
    it "should have the expected value in VX, Vx = VX ^ VY" do
      vx_position = 0xC
      vy_position = 0x5
      subject.set_variable_in_position(vx_position, 0b10101010)
      subject.set_variable_in_position(vy_position, 0b10001111)

      subject.bitwise_logical_xor(vx_position, vy_position)

      result = subject.instance_variable_get(:@variable)[vx_position]

      expect(result).to eq 0b00100101
    end
  end

  context "#bitwise_logical_shift" do
    it "should have the expected value in VX, Vx = VY >> 1 & VF = 1" do
      vx_position = 0xC
      vy_position = 0x5
      subject.set_variable_in_position(vx_position, 0b10101001)
      subject.set_variable_in_position(vy_position, 0b10001111)

      subject.bitwise_logical_shift(vx_position, vy_position)

      variable = subject.instance_variable_get(:@variable)

      expect(variable[vx_position]).to eq 0b01000111
      expect(variable[0xF]).to eq 1
    end

    it "should have the expected value in VX, Vx = VY << 1 & VF = 0" do
      vx_position = 0xC
      vy_position = 0x5
      subject.set_variable_in_position(vx_position, 0b00101001)
      subject.set_variable_in_position(vy_position, 0b10001111)

      subject.bitwise_logical_shift(vx_position, vy_position, to_right: false)

      variable = subject.instance_variable_get(:@variable)

      expect(variable[vx_position]).to eq 0b00011110
      expect(variable[0xF]).to eq 0
    end
  end

  context "#set_random_value_into_variable" do
    it "should have the expected value in VX after a random number and extracting it" do
      value_to_extract = 0x1F
      generated_value = 0xFF
      vx_position = 0xA

      allow(Random).to receive(:rand).with(0xFF).and_return(generated_value)

      subject.set_random_value_into_variable(vx_position, value_to_extract)

      result = subject.instance_variable_get(:@variable)[vx_position]

      expect(result).to eq 0x1F
    end
  end

  context "#sum_variable_from_into" do
    it "should sum the value from Vy into VX and store on VX and Store VF =1" do
      vx_position = 0xA
      vy_position = 0x1

      subject.set_variable_in_position(vx_position, 0xFF)
      subject.set_variable_in_position(vy_position, 0x15)

      subject.sum_variable_from_into(vy_position, vx_position)

      variable_values = subject.instance_variable_get(:@variable)

      expect(variable_values[vx_position]).to eq 0x14
      expect(variable_values[0xF]).to eq 0x1
    end

    it "should sum the value from VY into VX and store on VX and Store VF = 0" do
      vx_position = 0xB
      vy_position = 0xC

      subject.set_variable_in_position(vx_position, 0xF)
      subject.set_variable_in_position(vy_position, 0x1)

      subject.sum_variable_from_into(vy_position, vx_position)

      variable_values = subject.instance_variable_get(:@variable)

      expect(variable_values[vx_position]).to eq 0x10
      expect(variable_values[0xF]).to eq 0x0
    end

    it "should raise an argument error if variable_y_pos > 0xF" do
      expect { subject.sum_variable_from_into(0x10, 0xF) }.to raise_error(ArgumentError)
    end

    it "should raise an argument error if variable_x_pos > 0xF" do
      expect { subject.sum_variable_from_into(0x1, 0xFF) }.to raise_error(ArgumentError)
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

  context "#new_display_data" do
    it "should return a Matrix with the new display_data" do
      display_buffer = Matrix.zero(32, 64)
      memory_double = instance_double("Chip8::Components::Memory")
      allow(memory_double).to receive(:access).and_return(0b10101010)
      subject.set_variable_in_position(0xF, 0x1)

      result = subject.new_display_data(0x1, 0x2, 0x5, memory_double, display_buffer)

      current_index = subject.index
      current_vf = subject.instance_variable_get(:@variable)[0xF]
      expect(current_index).to eq 0
      expect(current_index.class).to eq Integer
      expect(current_vf).to eq 0
      expect(result).not_to eq Matrix.zero(32, 64)
    end

    it "should return a Matrix with the new display_data breaking if X or Y 'overflow' the screen" do
      stub_const("Chip8::Components::Display::WIDTH", 7)
      stub_const("Chip8::Components::Display::HEIGHT", 5)
      memory_double = instance_double("Chip8::Components::Memory")
      allow(memory_double).to receive(:access).and_return(0b10101010)

      display_buffer = Matrix.zero(15, 15)

      new_variable = Array.new(15, 0x9)
      subject.instance_variable_set(:@variable, new_variable)
      result = subject.new_display_data(0x1, 0x2, 0x5, memory_double, display_buffer)

      current_index = subject.index

      current_vf = subject.instance_variable_get(:@variable)[0xF]
      expect(current_index).to eq 0
      expect(current_vf).to eq 0
      expect(result).not_to eq Matrix.zero(15, 15)
    end

    it "should return with VF = 1" do
      stub_const("Chip8::Components::Display::WIDTH", 2)
      stub_const("Chip8::Components::Display::HEIGHT", 2)
      memory_double = instance_double("Chip8::Components::Memory")
      allow(memory_double).to receive(:access).and_return(0b10101010)

      display_buffer = Matrix.rows([[1, 1], [1, 1]])

      new_variable = Array.new(15, 0x9)
      subject.instance_variable_set(:@variable, new_variable)
      result = subject.new_display_data(0x1, 0x2, 0x2, memory_double, display_buffer)

      current_index = subject.index

      current_vf = subject.instance_variable_get(:@variable)[0xF]
      expect(current_index).to eq 0
      expect(current_vf).to eq 1
      expect(result).not_to eq Matrix.zero(15, 15)
    end
  end
end
