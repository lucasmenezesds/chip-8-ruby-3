# frozen_string_literal: true

require "matrix"
require "gosu"

describe Chip8::Components::Display do
  before do
    @cpu_double = instance_double("Chip8::Components::CPUStatus")
    @keyboard_double = instance_double("Chip8::Components::Keyboard")
    @clock_double = instance_double("Chip8::Components::Clock")
  end

  context "after initialized" do
    subject do
      described_class.new(cpu_status: @cpu_double,
                          keyboard: @keyboard_double,
                          clock: @clock_double)
    end
    it "should have the expected caption" do
      caption = subject.caption

      expect(caption).to eq "CHIP-8 Display"
    end
  end

  context "mocking the constants" do
    before(:example) do
      stub_const("Chip8::Components::Display::WIDTH", 3)
      stub_const("Chip8::Components::Display::HEIGHT", 2)
      stub_const("Chip8::Components::Display::SCALE", 1)

      @mocked_display = described_class.new(cpu_status: @cpu_double,
                                            keyboard: @keyboard_double,
                                            clock: @clock_double)
    end

    context "#update_display_buffer" do
      it "should update the matrix data" do
        matrix_data = [[1, 2], [3, 4], [5, 6]]
        matrix = Matrix.rows(matrix_data)
        @mocked_display.update_display_buffer(matrix)

        expect(@mocked_display.display_buffer.class.to_s).to eq "Matrix"
        expect(@mocked_display.display_buffer).to match(matrix)
        expect(@mocked_display.display_buffer).not_to match(Matrix.zero(3, 2))
      end
    end

    context "#clean_display" do
      it "should set all matrix data as zero" do
        matrix_data = [[1, 2], [3, 4], [5, 6]]
        matrix = Matrix.rows(matrix_data)
        @mocked_display.clean_display

        expect(@mocked_display.display_buffer.class.to_s).to eq "Matrix"
        expect(@mocked_display.display_buffer).to match(Matrix.zero(3, 2))
        expect(@mocked_display.display_buffer).not_to match(matrix)
      end
    end

    context "#draw" do
      it "should have the method called without breaking" do
        allow(@mocked_display).to receive(:draw_rect)

        matrix_data = [[0, 0], [3, 0], [5, 6]]
        matrix = Matrix.rows(matrix_data)

        expect(@mocked_display.instance_variable_get(:@pixel_texture)).to receive(:draw).at_least(:once)
        @mocked_display.update_display_buffer(matrix)
        @mocked_display.draw
      end
    end

    describe "#create_pixel_texture" do
      it 'creates a texture of the correct size' do
        texture = @mocked_display.send(:create_pixel_texture)
        expect(texture.width).to eq(described_class::SCALE)
        expect(texture.height).to eq(described_class::SCALE)
      end
    end

    context "#button_down" do
      it "should have the method called once" do
        expect(@mocked_display).to receive(:button_down).with(Gosu::KB_ESCAPE)

        @mocked_display.button_down(Gosu::KB_ESCAPE) # Gosu::KB_ESCAPE
      end

      it "should call the @halt_option.stop_it method once" do
        allow(@cpu_double).to receive(:stop_it)
        expect(@mocked_display).to receive(:puts).exactly(1)

        @mocked_display.button_down(Gosu::KB_ESCAPE)
      end

      it "should allow the method to receive invalid id" do
        allow(@keyboard_double).to receive(:press_key).with(nil)

        expect(@mocked_display.button_down(nil)).to be_nil
      end

      it "should shift the $STEP_BY_STEP_FLAG flag value" do
        $STEP_BY_STEP_FLAG = true

        @mocked_display.button_down(Gosu::KB_P) # Gosu::KB_ESCAPE
        expect($STEP_BY_STEP_FLAG).to be_falsey
      end

      it "should call @clock.decrease_cpu_clock" do
        expect(@clock_double).to receive(:decrease_cpu_clock).exactly(1)

        @mocked_display.button_down(Gosu::KB_8)
      end

      it "should call @clock.increase_cpu_clock" do
        expect(@clock_double).to receive(:increase_cpu_clock).exactly(1)

        @mocked_display.button_down(Gosu::KB_9)
      end

      it "should call @clock.reset_cpu_clock" do
        expect(@clock_double).to receive(:reset_cpu_clock).exactly(1)

        @mocked_display.button_down(Gosu::KB_0)
      end
    end

    context "#button_up" do
      it "should have the method called once" do
        expect(@mocked_display).to receive(:button_up).with(Gosu::KB_ESCAPE).once

        @mocked_display.button_up(41) # Gosu::KB_ESCAPE
      end

      it "should have the method close called once" do
        expect(@mocked_display).to receive(:close).once

        @mocked_display.button_up(Gosu::KB_ESCAPE) # Gosu::KB_ESCAPE
      end

      it "should allow the method to receive invalid id" do
        allow(@keyboard_double).to receive(:release_key).with(nil)

        expect(@mocked_display.button_up(nil)).to be_nil
      end
    end

    context "#update" do
      it "should have the clock methods " do
        expect(@clock_double).to receive(:tick_delay_timer).exactly(1)
        expect(@clock_double).to receive(:tick_sound_timer).exactly(1)

        @mocked_display.update
      end
    end
  end
end
