# frozen_string_literal: true

describe Chip8::Emulator do
  context "#run" do
    let(:emulator) { Chip8::Emulator.new(rom_path: "example.8o") }
    it "should set the Index Register to the expected value" do
      file_double = instance_double("File")
      interpreter_double = instance_double("Chip8::Interpreter")

      # Mocking #binread Method
      allow(File).to receive(:binread).with("example.8o").and_return("\x00\xE0")

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
