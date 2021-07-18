# frozen_string_literal: true

require "matrix"

describe Chip8::Components::Display do
  context "when initialized" do
    cpu_status = Chip8::Components::CPUStatus.new
    subject { described_class.new(cpu_status) }
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
      @cpu_status = Chip8::Components::CPUStatus.new
      @mocked_display = described_class.new(@cpu_status)
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

        @mocked_display.update_display_buffer(matrix)
        @mocked_display.draw
      end
    end

    context "#button_down" do
      it "should have the method called once" do
        expect(@mocked_display).to receive(:button_down).with(41)

        @mocked_display.button_down(41) # Gosu::KB_ESCAPE
      end

      it "should call the @halt_option.stop_it method once" do
        @mocked_display.button_down(41) # Gosu::KB_ESCAPE

        allow_any_instance_of(Chip8::Components::CPUStatus).to receive(:stop_it)
      end

      it "should allow the method to receive invalid id" do
        expect(@mocked_display.button_down(nil)).to be_nil
      end
    end

    context "#button_up" do
      it "should have the method called once" do
        expect(@mocked_display).to receive(:button_up).with(41).once

        @mocked_display.button_up(41) # Gosu::KB_ESCAPE
      end

      it "should have the method close called once" do
        expect(@mocked_display).to receive(:close).once

        @mocked_display.button_up(41) # Gosu::KB_ESCAPE
      end

      it "should allow the method to receive invalid id" do
        expect(@mocked_display.button_up(nil)).to be_nil
      end
    end
  end
end
