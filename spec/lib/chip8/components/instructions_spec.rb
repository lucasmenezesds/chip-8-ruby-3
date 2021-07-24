# frozen_string_literal: true

describe Chip8::Components::Instructions do
  before do
    @display_double = instance_double("Chip8::Components::Display")
    @register_double = instance_double("Chip8::Components::Register")
    @program_counter_double = instance_double("Chip8::Components::ProgramCounter")
    @memory_double = instance_double("Chip8::Components::Memory")
    @keyboard_double = instance_double("Chip8::Components::Keyboard")
    @stack_double = instance_double("Chip8::Components::Stack")
    @clock_double = instance_double("Chip8::Components::Clock")
  end

  context "#run" do
    context "case: 0x0" do
      context "case: 0x00E0" do
        it "should go into instruction case" do
          nibble = { "instruction" => 0x0, "x" => 0, "y" => 0,
                     "n" => nil, "nn" => nil, "nnn" => 0x0E0 }

          allow(described_class).to receive(:debug)

          expect(@display_double).to receive(:clean_display).once

          described_class.run(nibble, display: @display_double,
                              register: @register_double,
                              program_counter: @program_counter_double,
                              memory: @memory_double,
                              keyboard: @keyboard_double,
                              stack: @stack_double,
                              clock: @clock_double)
        end
      end
    end

    context "case: 0x1" do
      it "should go into instruction case" do
        nibble = { "instruction" => 0x1, "x" => 0, "y" => 0,
                   "n" => nil, "nn" => nil, "nnn" => 0xF }

        allow(described_class).to receive(:debug)

        expect(@program_counter_double).to receive(:new_position)
                                             .with(nibble["nnn"])
                                             .once

        described_class.run(nibble, display: @display_double,
                            register: @register_double,
                            program_counter: @program_counter_double,
                            memory: @memory_double,
                            keyboard: @keyboard_double,
                            stack: @stack_double,
                            clock: @clock_double)
      end
    end

    context "case: 0x6" do
      it "should go into instruction case" do
        nibble = { "instruction" => 0x6, "x" => 1, "y" => 0,
                   "n" => nil, "nn" => 0xF, "nnn" => nil }

        allow(described_class).to receive(:debug)

        expect(@register_double).to receive(:set_variable_in_position)
                                      .with(nibble["x"], nibble["nn"])
                                      .once

        described_class.run(nibble, display: @display_double,
                            register: @register_double,
                            program_counter: @program_counter_double,
                            memory: @memory_double,
                            keyboard: @keyboard_double,
                            stack: @stack_double,
                            clock: @clock_double)
      end
    end

    context "case: 0x7" do
      it "should go into instruction case" do
        nibble = { "instruction" => 0x7, "x" => 0x7, "y" => 0,
                   "n" => nil, "nn" => 0x7, "nnn" => nil }

        allow(described_class).to receive(:debug)

        expect(@register_double).to receive(:add_to_variable)
                                      .with(nibble["x"], nibble["nn"])
                                      .once

        described_class.run(nibble, display: @display_double,
                            register: @register_double,
                            program_counter: @program_counter_double,
                            memory: @memory_double,
                            keyboard: @keyboard_double,
                            stack: @stack_double,
                            clock: @clock_double)
      end
    end

    context "case: 0xA" do
      it "should go into instruction case" do
        nibble = { "instruction" => 0xA, "x" => 0, "y" => 0,
                   "n" => nil, "nn" => nil, "nnn" => 0xA }

        allow(described_class).to receive(:debug)

        expect(@register_double).to receive(:set_index)
                                      .with(nibble["nnn"])
                                      .once

        described_class.run(nibble, display: @display_double,
                            register: @register_double,
                            program_counter: @program_counter_double,
                            memory: @memory_double,
                            keyboard: @keyboard_double,
                            stack: @stack_double,
                            clock: @clock_double)
      end
    end

    context "case: 0xD" do
      it "should go into instruction case" do
        nibble = { "instruction" => 0xD, "x" => 0xD, "y" => 0xD,
                   "n" => 0xD, "nn" => nil, "nnn" => nil }

        mock_matrix = Matrix.zero(1, 1)

        allow(described_class).to receive(:debug)
        allow(@display_double).to receive(:display_buffer).and_return(@display_double)
        allow(@memory_double).to receive(:access)

        expect(@register_double).to receive(:new_display_data)
                                      .with(nibble["x"],
                                            nibble["y"],
                                            nibble["n"],
                                            @memory_double,
                                            @display_double)
                                      .and_return(mock_matrix)
                                      .once

        expect(@display_double).to receive(:update_display_buffer)
                                     .with(Matrix.zero(1, 1))
                                     .once

        described_class.run(nibble, display: @display_double,
                            register: @register_double,
                            program_counter: @program_counter_double,
                            memory: @memory_double,
                            keyboard: @keyboard_double,
                            stack: @stack_double,
                            clock: @clock_double)
      end
    end

    context "case: Invalid" do
      it "should go into instruction case and puts 'do nothing'" do
        nibble = { "instruction" => 0xFFFFF, "x" => 0, "y" => 0,
                   "n" => nil, "nn" => nil, "nnn" => nil }

        expect(described_class).to receive(:puts).once

        described_class.run(nibble, display: @display_double,
                            register: @register_double,
                            program_counter: @program_counter_double,
                            memory: @memory_double,
                            keyboard: @keyboard_double,
                            stack: @stack_double,
                            clock: @clock_double)
      end
    end
  end
end
