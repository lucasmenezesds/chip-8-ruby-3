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

    # For when values needs to be checked
    @register = Chip8::Components::Register.new
    @program_counter = Chip8::Components::ProgramCounter.new(starting_index: 0x200)
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
      context "case: 0x00EE" do
        it "should go into instruction case and call its methods" do
          nibble = { "instruction" => 0x0, "x" => 0, "y" => 0,
                     "n" => nil, "nn" => nil, "nnn" => 0x0EE }

          allow(@stack_double).to receive(:pop_data).and_return(10)

          expect(@program_counter_double).to receive(:update_index).once

          described_class.run(nibble, display: @display_double,
                                      register: @register_double,
                                      program_counter: @program_counter_double,
                                      memory: @memory_double,
                                      keyboard: @keyboard_double,
                                      stack: @stack_double,
                                      clock: @clock_double)
        end
      end

      it "should go into else case" do
        nibble = { "instruction" => 0x0, "x" => 0, "y" => 0,
                   "n" => nil, "nn" => nil, "nnn" => 0x0 }

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

    context "case: 0x1" do
      context "case: 1NNN" do
        it "should go into instruction case" do
          nibble = { "instruction" => 0x1, "x" => 0, "y" => 0,
                     "n" => nil, "nn" => nil, "nnn" => 0xF }

          allow(Chip8::Helpers::Debug).to receive(:debug)

          expect(@program_counter_double).to receive(:update_index)
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
    end

    context "case: 0x2" do
      context "case: 2NNN" do
        it "should go into instruction case" do
          nibble = { "instruction" => 0x2, "x" => 0, "y" => 0,
                     "n" => nil, "nn" => nil, "nnn" => 0xF }

          allow(Chip8::Helpers::Debug).to receive(:debug)

          expect(@program_counter_double).to receive(:index).once

          expect(@stack_double).to receive(:push_data).once

          expect(@program_counter_double).to receive(:update_index)
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
    end

    context "case: 0x3" do
      context "case: 3XNN" do
        it "should go into instruction case on IF case" do
          nibble = { "instruction" => 0x3, "x" => 3, "y" => 0,
                     "n" => nil, "nn" => 0xF, "nnn" => nil }

          allow(Chip8::Helpers::Debug).to receive(:debug)

          allow(@register).to receive(:get_variable_in_position).with(nibble["x"]).and_return(0xF)

          described_class.run(nibble, display: @display_double,
                                      register: @register,
                                      program_counter: @program_counter,
                                      memory: @memory_double,
                                      keyboard: @keyboard_double,
                                      stack: @stack_double,
                                      clock: @clock_double)

          expect(@program_counter.index).to eq 0x202
        end

        it "should go into instruction case on ELSE case" do
          nibble = { "instruction" => 0x3, "x" => 3, "y" => 0,
                     "n" => nil, "nn" => 0xF, "nnn" => nil }

          allow(Chip8::Helpers::Debug).to receive(:debug)

          allow(@register).to receive(:get_variable_in_position).with(nibble["x"]).and_return(0xA)

          described_class.run(nibble, display: @display_double,
                                      register: @register,
                                      program_counter: @program_counter,
                                      memory: @memory_double,
                                      keyboard: @keyboard_double,
                                      stack: @stack_double,
                                      clock: @clock_double)

          expect(@program_counter.index).to eq 0x200
        end
      end
    end

    context "case: 0x4" do
      context "case: 4XNN" do
        it "should go into instruction case on IF case" do
          nibble = { "instruction" => 0x4, "x" => 4, "y" => 0,
                     "n" => nil, "nn" => 0xF, "nnn" => nil }

          allow(Chip8::Helpers::Debug).to receive(:debug)

          allow(@register).to receive(:get_variable_in_position).with(nibble["x"]).and_return(0xA)

          described_class.run(nibble, display: @display_double,
                                      register: @register,
                                      program_counter: @program_counter,
                                      memory: @memory_double,
                                      keyboard: @keyboard_double,
                                      stack: @stack_double,
                                      clock: @clock_double)

          expect(@program_counter.index).to eq 0x202
        end

        it "should go into instruction case on ELSE case" do
          nibble = { "instruction" => 0x4, "x" => 4, "y" => 0,
                     "n" => nil, "nn" => 0xF, "nnn" => nil }

          allow(Chip8::Helpers::Debug).to receive(:debug)

          allow(@register).to receive(:get_variable_in_position).with(nibble["x"]).and_return(0xF)

          described_class.run(nibble, display: @display_double,
                                      register: @register,
                                      program_counter: @program_counter,
                                      memory: @memory_double,
                                      keyboard: @keyboard_double,
                                      stack: @stack_double,
                                      clock: @clock_double)

          expect(@program_counter.index).to eq 0x200
        end
      end
    end

    context "case: 0x5" do
      context "case: 5XY0" do
        it "should go into instruction case on IF case" do
          nibble = { "instruction" => 0x5, "x" => 5, "y" => 10,
                     "n" => nil, "nn" => 0xF, "nnn" => nil }

          allow(Chip8::Helpers::Debug).to receive(:debug)

          allow(@register).to receive(:get_variable_in_position).with(nibble["x"]).and_return(0xA)
          allow(@register).to receive(:get_variable_in_position).with(nibble["y"]).and_return(0xA)

          described_class.run(nibble, display: @display_double,
                                      register: @register,
                                      program_counter: @program_counter,
                                      memory: @memory_double,
                                      keyboard: @keyboard_double,
                                      stack: @stack_double,
                                      clock: @clock_double)

          expect(@program_counter.index).to eq 0x202
        end

        it "should go into instruction case on ELSE case" do
          nibble = { "instruction" => 0x5, "x" => 5, "y" => 10,
                     "n" => nil, "nn" => 0xF, "nnn" => nil }

          allow(Chip8::Helpers::Debug).to receive(:debug)

          allow(@register).to receive(:get_variable_in_position).with(nibble["x"]).and_return(0xA)
          allow(@register).to receive(:get_variable_in_position).with(nibble["y"]).and_return(0xC)

          described_class.run(nibble, display: @display_double,
                                      register: @register,
                                      program_counter: @program_counter,
                                      memory: @memory_double,
                                      keyboard: @keyboard_double,
                                      stack: @stack_double,
                                      clock: @clock_double)

          expect(@program_counter.index).to eq 0x200
        end
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

    context "case: 0x9" do
      context "case: 9XY0" do
        it "should go into instruction case on IF case" do
          nibble = { "instruction" => 0x9, "x" => 9, "y" => 11,
                     "n" => nil, "nn" => nil, "nnn" => nil }

          allow(Chip8::Helpers::Debug).to receive(:debug)

          allow(@register).to receive(:get_variable_in_position).with(nibble["x"]).and_return(0x1)
          allow(@register).to receive(:get_variable_in_position).with(nibble["y"]).and_return(0x2)

          described_class.run(nibble, display: @display_double,
                                      register: @register,
                                      program_counter: @program_counter,
                                      memory: @memory_double,
                                      keyboard: @keyboard_double,
                                      stack: @stack_double,
                                      clock: @clock_double)

          expect(@program_counter.index).to eq 0x202
        end

        it "should go into instruction case on ELSE case" do
          nibble = { "instruction" => 0x9, "x" => 9, "y" => 11,
                     "n" => nil, "nn" => nil, "nnn" => nil }

          allow(Chip8::Helpers::Debug).to receive(:debug)

          allow(@register).to receive(:get_variable_in_position).with(nibble["x"]).and_return(0x1)
          allow(@register).to receive(:get_variable_in_position).with(nibble["y"]).and_return(0x1)

          described_class.run(nibble, display: @display_double,
                                      register: @register,
                                      program_counter: @program_counter,
                                      memory: @memory_double,
                                      keyboard: @keyboard_double,
                                      stack: @stack_double,
                                      clock: @clock_double)

          expect(@program_counter.index).to eq 0x200
        end
      end
    end

    context "case: 0xA" do
      it "should go into instruction case" do
        nibble = { "instruction" => 0xA, "x" => 0, "y" => 0,
                   "n" => nil, "nn" => nil, "nnn" => 0xA }

        allow(described_class).to receive(:debug)

        expect(@register_double).to receive(:update_index)
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

    context "case: 0xB" do
      context "case: BNNN" do
        it "should go into instruction case" do
          nibble = { "instruction" => 0xB, "x" => 0, "y" => 0,
                     "n" => nil, "nn" => nil, "nnn" => 0xF }

          allow(Chip8::Helpers::Debug).to receive(:debug)

          described_class.run(nibble, display: @display_double,
                                      register: @register,
                                      program_counter: @program_counter,
                                      memory: @memory_double,
                                      keyboard: @keyboard_double,
                                      stack: @stack_double,
                                      clock: @clock_double)

          expect(@program_counter.index).to eq 0xF
        end
      end
    end

    context "case: 0xC" do
      context "case: CXNN" do
        it "should go into instruction case" do
          nibble = { "instruction" => 0xC, "x" => 3, "y" => 0,
                     "n" => nil, "nn" => 0xF, "nnn" => nil }

          allow(Chip8::Helpers::Debug).to receive(:debug)

          expect(@register_double).to receive(:set_random_value_into_variable).once

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

    context "case: 0xE" do
      context "case: EX9E" do
        it "should go into instruction case on IF case" do
          nibble = { "instruction" => 0xE, "x" => 5, "y" => 0,
                     "n" => nil, "nn" => 0x9E, "nnn" => nil }

          allow(Chip8::Helpers::Debug).to receive(:debug)

          allow(@register).to receive(:get_variable_in_position).with(nibble["x"]).and_return(nibble["x"])
          allow(@keyboard_double).to receive(:key_pressed?).with(nibble["x"]).and_return(true)

          described_class.run(nibble, display: @display_double,
                                      register: @register,
                                      program_counter: @program_counter,
                                      memory: @memory_double,
                                      keyboard: @keyboard_double,
                                      stack: @stack_double,
                                      clock: @clock_double)

          expect(@program_counter.index).to eq 0x202
        end

        it "should go into instruction case on ELSE case" do
          nibble = { "instruction" => 0xE, "x" => 5, "y" => 0,
                     "n" => nil, "nn" => 0x9E, "nnn" => nil }

          allow(Chip8::Helpers::Debug).to receive(:debug)

          allow(@register).to receive(:get_variable_in_position).with(nibble["x"]).and_return(nibble["x"])
          allow(@keyboard_double).to receive(:key_pressed?).with(nibble["x"]).and_return(false)

          described_class.run(nibble, display: @display_double,
                                      register: @register,
                                      program_counter: @program_counter,
                                      memory: @memory_double,
                                      keyboard: @keyboard_double,
                                      stack: @stack_double,
                                      clock: @clock_double)

          expect(@program_counter.index).to eq 0x200
        end
      end

      context "case: EXA1" do
        it "should go into instruction case on IF case" do
          nibble = { "instruction" => 0xE, "x" => 9, "y" => 0,
                     "n" => nil, "nn" => 0xA1, "nnn" => nil }

          allow(Chip8::Helpers::Debug).to receive(:debug)

          allow(@register).to receive(:get_variable_in_position).with(nibble["x"]).and_return(nibble["x"])
          allow(@keyboard_double).to receive(:key_pressed?).with(nibble["x"]).and_return(false)

          described_class.run(nibble, display: @display_double,
                                      register: @register,
                                      program_counter: @program_counter,
                                      memory: @memory_double,
                                      keyboard: @keyboard_double,
                                      stack: @stack_double,
                                      clock: @clock_double)

          expect(@program_counter.index).to eq 0x202
        end

        it "should go into instruction case on ELSE case" do
          nibble = { "instruction" => 0xE, "x" => 9, "y" => 0,
                     "n" => nil, "nn" => 0xA1, "nnn" => nil }

          allow(Chip8::Helpers::Debug).to receive(:debug)

          allow(@register).to receive(:get_variable_in_position).with(nibble["x"]).and_return(nibble["x"])
          allow(@keyboard_double).to receive(:key_pressed?).with(nibble["x"]).and_return(true)

          described_class.run(nibble, display: @display_double,
                                      register: @register,
                                      program_counter: @program_counter,
                                      memory: @memory_double,
                                      keyboard: @keyboard_double,
                                      stack: @stack_double,
                                      clock: @clock_double)

          expect(@program_counter.index).to eq 0x200
        end
      end

      it "should go into else condition from the switch case" do
        nibble = { "instruction" => 0xE, "x" => 9, "y" => 0,
                   "n" => nil, "nn" => 0x0, "nnn" => nil }

        allow(Chip8::Helpers::Debug).to receive(:debug).exactly(0)
        allow(described_class).to receive(:puts).exactly(1)

        described_class.run(nibble, display: @display_double,
                                    register: @register,
                                    program_counter: @program_counter,
                                    memory: @memory_double,
                                    keyboard: @keyboard_double,
                                    stack: @stack_double,
                                    clock: @clock_double)
      end
    end

    context "case: 0xF" do
      context "case: FX07" do
        it "should go into instruction" do
          nibble = { "instruction" => 0xF, "x" => 5, "y" => 0,
                     "n" => nil, "nn" => 0x07, "nnn" => nil }

          allow(Chip8::Helpers::Debug).to receive(:debug)

          expect(@clock_double).to receive(:delay_timer).once
          expect(@register_double).to receive(:set_variable_in_position).once

          described_class.run(nibble, display: @display_double,
                                      register: @register_double,
                                      program_counter: @program_counter_double,
                                      memory: @memory_double,
                                      keyboard: @keyboard_double,
                                      stack: @stack_double,
                                      clock: @clock_double)
        end
      end

      context "case: FX0A" do
        it "should go into instruction IF Condition" do
          nibble = { "instruction" => 0xF, "x" => 0xA, "y" => 0,
                     "n" => nil, "nn" => 0x0A, "nnn" => nil }

          allow(Chip8::Helpers::Debug).to receive(:debug)

          allow(@keyboard_double).to receive(:position_of_key_pressed).and_return(nil)
          expect(@program_counter_double).to receive(:decrement_index_position).once

          described_class.run(nibble, display: @display_double,
                                      register: @register_double,
                                      program_counter: @program_counter_double,
                                      memory: @memory_double,
                                      keyboard: @keyboard_double,
                                      stack: @stack_double,
                                      clock: @clock_double)
        end

        it "should go into instruction ELSE Condition" do
          nibble = { "instruction" => 0xF, "x" => 0xA, "y" => 0,
                     "n" => nil, "nn" => 0x0A, "nnn" => nil }

          allow(Chip8::Helpers::Debug).to receive(:debug)

          allow(@keyboard_double).to receive(:position_of_key_pressed).and_return(0x5)
          expect(@register_double).to receive(:set_variable_in_position).once

          described_class.run(nibble, display: @display_double,
                                      register: @register_double,
                                      program_counter: @program_counter_double,
                                      memory: @memory_double,
                                      keyboard: @keyboard_double,
                                      stack: @stack_double,
                                      clock: @clock_double)
        end
      end

      context "case: FX15" do
        it "should go into instruction" do
          nibble = { "instruction" => 0xF, "x" => 0, "y" => 0,
                     "n" => nil, "nn" => 0x15, "nnn" => nil }

          allow(Chip8::Helpers::Debug).to receive(:debug)

          allow(@register_double).to receive(:get_variable_in_position).and_return(0x5)
          expect(@clock_double).to receive(:update_delay_timer).with(0x5).once

          described_class.run(nibble, display: @display_double,
                                      register: @register_double,
                                      program_counter: @program_counter_double,
                                      memory: @memory_double,
                                      keyboard: @keyboard_double,
                                      stack: @stack_double,
                                      clock: @clock_double)
        end
      end

      context "case: FX18" do
        it "should go into instruction" do
          nibble = { "instruction" => 0xF, "x" => 0, "y" => 0,
                     "n" => nil, "nn" => 0x18, "nnn" => nil }

          allow(Chip8::Helpers::Debug).to receive(:debug)

          allow(@register_double).to receive(:get_variable_in_position).and_return(0xA)
          expect(@clock_double).to receive(:update_sound_timer).with(0xA).once

          described_class.run(nibble, display: @display_double,
                                      register: @register_double,
                                      program_counter: @program_counter_double,
                                      memory: @memory_double,
                                      keyboard: @keyboard_double,
                                      stack: @stack_double,
                                      clock: @clock_double)
        end
      end

      context "case: FX1E" do
        it "should go into instruction" do
          nibble = { "instruction" => 0xF, "x" => 0, "y" => 0,
                     "n" => nil, "nn" => 0x1E, "nnn" => nil }

          allow(Chip8::Helpers::Debug).to receive(:debug)

          allow(@register_double).to receive(:get_variable_in_position).and_return(0xA)
          allow(@register_double).to receive(:index).and_return(0x5)
          allow(@register_double).to receive(:update_index).with(0xF).once

          described_class.run(nibble, display: @display_double,
                                      register: @register_double,
                                      program_counter: @program_counter_double,
                                      memory: @memory_double,
                                      keyboard: @keyboard_double,
                                      stack: @stack_double,
                                      clock: @clock_double)
        end
      end

      context "case: FX29" do
        it "should go into instruction" do
          nibble = { "instruction" => 0xF, "x" => 1, "y" => 0,
                     "n" => nil, "nn" => 0x29, "nnn" => nil }

          allow(Chip8::Helpers::Debug).to receive(:debug)

          allow(@register_double).to receive(:get_variable_in_position).and_return(0xA)
          allow(@register_double).to receive(:update_index).with(0x82).once # Because of the Font starting address

          described_class.run(nibble, display: @display_double,
                                      register: @register_double,
                                      program_counter: @program_counter_double,
                                      memory: @memory_double,
                                      keyboard: @keyboard_double,
                                      stack: @stack_double,
                                      clock: @clock_double)
        end
      end

      context "case: FX33" do
        it "should go into instruction" do
          nibble = { "instruction" => 0xF, "x" => 0x8, "y" => 0,
                     "n" => nil, "nn" => 0x33, "nnn" => nil }

          allow(Chip8::Helpers::Debug).to receive(:debug)

          memory = Chip8::Components::Memory.new

          allow(@register_double).to receive(:index).and_return(0xA)
          allow(@register_double).to receive(:get_variable_in_position).with(nibble["x"]).and_return(253)

          described_class.run(nibble, display: @display_double,
                                      register: @register_double,
                                      program_counter: @program_counter_double,
                                      memory: memory,
                                      keyboard: @keyboard_double,
                                      stack: @stack_double,
                                      clock: @clock_double)

          expect(memory.access(0xA)).to eq 2
          expect(memory.access(0xB)).to eq 5
          expect(memory.access(0xC)).to eq 3
        end
      end

      context "case: FX55" do
        it "should go into instruction" do
          nibble = { "instruction" => 0xF, "x" => 0x0, "y" => 0,
                     "n" => nil, "nn" => 0x55, "nnn" => nil }

          allow(Chip8::Helpers::Debug).to receive(:debug)

          allow(@register_double).to receive(:index).and_return(0xA)
          allow(@register_double).to receive(:get_variable_in_position).with(nibble["x"]).and_return(0x5)

          expect(@memory_double).to receive(:update_value).with(0xA, 0x5).once

          described_class.run(nibble, display: @display_double,
                                      register: @register_double,
                                      program_counter: @program_counter_double,
                                      memory: @memory_double,
                                      keyboard: @keyboard_double,
                                      stack: @stack_double,
                                      clock: @clock_double)
        end
      end

      context "case: FX65" do
        it "should go into instruction" do
          nibble = { "instruction" => 0xF, "x" => 0x0, "y" => 0,
                     "n" => nil, "nn" => 0x65, "nnn" => nil }

          allow(Chip8::Helpers::Debug).to receive(:debug)

          allow(@register_double).to receive(:index).and_return(0xA)
          allow(@memory_double).to receive(:access).with(0xA).and_return(0x9).once

          expect(@register_double).to receive(:set_variable_in_position).with(0x0, 0x9)

          described_class.run(nibble, display: @display_double,
                                      register: @register_double,
                                      program_counter: @program_counter_double,
                                      memory: @memory_double,
                                      keyboard: @keyboard_double,
                                      stack: @stack_double,
                                      clock: @clock_double)
        end
      end

      it "should go into instruction case and puts 'do nothing'" do
        nibble = { "instruction" => 0xF, "x" => 0, "y" => 0,
                   "n" => nil, "nn" => 0xFF, "nnn" => nil }

        allow(Chip8::Helpers::Debug).to receive(:debug).exactly(0)
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

    context "case: 0x8" do
      context "#arithmetical_methods" do
        context "case: 8XY0" do
          it "should call register#copy_variable_data_from_to" do
            nibble = { "instruction" => 0x8, "x" => 0, "y" => 0,
                       "n" => 0, "nn" => nil, "nnn" => nil }

            allow(Chip8::Helpers::Debug).to receive(:debug)

            expect(@register_double).to receive(:copy_variable_data_from_to).once

            described_class.run(nibble, display: @display_double,
                                        register: @register_double,
                                        program_counter: @program_counter_double,
                                        memory: @memory_double,
                                        keyboard: @keyboard_double,
                                        stack: @stack_double,
                                        clock: @clock_double)
          end
        end

        context "case: 8XY1" do
          it "should call register#bitwise_logical_or" do
            nibble = { "instruction" => 0x8, "x" => 0, "y" => 0,
                       "n" => 1, "nn" => nil, "nnn" => nil }

            allow(Chip8::Helpers::Debug).to receive(:debug)

            expect(@register_double).to receive(:bitwise_logical_or).once

            described_class.run(nibble, display: @display_double,
                                        register: @register_double,
                                        program_counter: @program_counter_double,
                                        memory: @memory_double,
                                        keyboard: @keyboard_double,
                                        stack: @stack_double,
                                        clock: @clock_double)
          end
        end

        context "case: 8XY2" do
          it "should call register#bitwise_logical_and" do
            nibble = { "instruction" => 0x8, "x" => 0, "y" => 0,
                       "n" => 2, "nn" => nil, "nnn" => nil }

            allow(Chip8::Helpers::Debug).to receive(:debug)

            expect(@register_double).to receive(:bitwise_logical_and).once

            described_class.run(nibble, display: @display_double,
                                        register: @register_double,
                                        program_counter: @program_counter_double,
                                        memory: @memory_double,
                                        keyboard: @keyboard_double,
                                        stack: @stack_double,
                                        clock: @clock_double)
          end
        end

        context "case: 8XY3" do
          it "should call register#bitwise_logical_xor" do
            nibble = { "instruction" => 0x8, "x" => 0, "y" => 0,
                       "n" => 3, "nn" => nil, "nnn" => nil }

            allow(Chip8::Helpers::Debug).to receive(:debug)

            expect(@register_double).to receive(:bitwise_logical_xor).once

            described_class.run(nibble, display: @display_double,
                                        register: @register_double,
                                        program_counter: @program_counter_double,
                                        memory: @memory_double,
                                        keyboard: @keyboard_double,
                                        stack: @stack_double,
                                        clock: @clock_double)
          end
        end

        context "case: 8XY4" do
          it "should call register#sum_variable_from_into" do
            nibble = { "instruction" => 0x8, "x" => 0, "y" => 0,
                       "n" => 4, "nn" => nil, "nnn" => nil }

            allow(Chip8::Helpers::Debug).to receive(:debug)

            expect(@register_double).to receive(:sum_variable_from_into).once

            described_class.run(nibble, display: @display_double,
                                        register: @register_double,
                                        program_counter: @program_counter_double,
                                        memory: @memory_double,
                                        keyboard: @keyboard_double,
                                        stack: @stack_double,
                                        clock: @clock_double)
          end
        end

        context "case: 8XY5" do
          it "should call register#subtract_variables" do
            nibble = { "instruction" => 0x8, "x" => 0, "y" => 0,
                       "n" => 5, "nn" => nil, "nnn" => nil }

            allow(Chip8::Helpers::Debug).to receive(:debug)

            expect(@register_double).to receive(:subtract_variables).once

            described_class.run(nibble, display: @display_double,
                                        register: @register_double,
                                        program_counter: @program_counter_double,
                                        memory: @memory_double,
                                        keyboard: @keyboard_double,
                                        stack: @stack_double,
                                        clock: @clock_double)
          end
        end

        context "case: 8XY6" do
          it "should call register#bitwise_logical_shift to the RIGHT" do
            nibble = { "instruction" => 0x8, "x" => 0, "y" => 0,
                       "n" => 6, "nn" => nil, "nnn" => nil }

            allow(Chip8::Helpers::Debug).to receive(:debug)

            expect(@register_double).to receive(:bitwise_logical_shift).once

            described_class.run(nibble, display: @display_double,
                                        register: @register_double,
                                        program_counter: @program_counter_double,
                                        memory: @memory_double,
                                        keyboard: @keyboard_double,
                                        stack: @stack_double,
                                        clock: @clock_double)
          end
        end

        context "case: 8XY7" do
          it "should call register#subtract_variables" do
            nibble = { "instruction" => 0x8, "x" => 0, "y" => 0,
                       "n" => 7, "nn" => nil, "nnn" => nil }

            allow(Chip8::Helpers::Debug).to receive(:debug)

            expect(@register_double).to receive(:subtract_variables).once

            described_class.run(nibble, display: @display_double,
                                        register: @register_double,
                                        program_counter: @program_counter_double,
                                        memory: @memory_double,
                                        keyboard: @keyboard_double,
                                        stack: @stack_double,
                                        clock: @clock_double)
          end
        end

        context "case: 8XYE" do
          it "should call register#bitwise_logical_shift to the LEFT" do
            nibble = { "instruction" => 0x8, "x" => 0, "y" => 0,
                       "n" => 0xE, "nn" => nil, "nnn" => nil }

            allow(Chip8::Helpers::Debug).to receive(:debug)

            expect(@register_double).to receive(:bitwise_logical_shift).once

            described_class.run(nibble, display: @display_double,
                                        register: @register_double,
                                        program_counter: @program_counter_double,
                                        memory: @memory_double,
                                        keyboard: @keyboard_double,
                                        stack: @stack_double,
                                        clock: @clock_double)
          end
        end

        context "case: invalid" do
          it "should go into else condition from the switch case" do
            nibble = { "instruction" => 0x8, "x" => 0, "y" => 0,
                       "n" => 0xF, "nn" => nil, "nnn" => nil }

            allow(Chip8::Helpers::Debug).to receive(:debug).exactly(0)
            allow(described_class).to receive(:puts).exactly(1)

            described_class.run(nibble, display: @display_double,
                                        register: @register,
                                        program_counter: @program_counter,
                                        memory: @memory_double,
                                        keyboard: @keyboard_double,
                                        stack: @stack_double,
                                        clock: @clock_double)
          end
        end
      end
    end

    context "no case" do
      context "case: Invalid" do
        it "should go into instruction case and puts 'do nothing'" do
          nibble = { "instruction" => 0xFFFFF, "x" => 0, "y" => 0,
                     "n" => nil, "nn" => nil, "nnn" => nil }

          allow(Chip8::Helpers::Debug).to receive(:debug).exactly(0)
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
end
