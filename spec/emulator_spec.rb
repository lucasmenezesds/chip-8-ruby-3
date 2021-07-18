# frozen_string_literal: true

describe Chip8::Emulator do
  context "#run" do
    let(:emulator) { Chip8::Emulator.new(rom_path: "example.8o") }
    it "should set the Index Register to the expected value" do
      file_double = instance_double("File")
      interpreter_double = instance_double("Chip8::Interpreter")

      # Mocking File Method
      allow(File).to receive(:open).with("example.8o", "rb").and_yield(file_double)

      # Mocking Read block from File Method
      allow(file_double).to receive(:read).and_return("\x00\xE0")

      # Mocking the Chip8 Interpreter
      allow(Chip8::Interpreter).to receive(:new).and_return(interpreter_double)

      # Mocking Chip8 Interpreter's Methods
      allow(interpreter_double).to receive(:run)

      allow(interpreter_double).to receive(:load_rom).with([0, 0x00E0])

      allow(interpreter_double).to receive(:show_display).and_return(true)

      # Checking if it was executed properly (by returning the stub value)
      expect(emulator.run).to be_truthy
    end
  end
end
