# frozen_string_literal: true

require "gosu"

describe Chip8::Components::Keyboard do
  context "after initialized" do
    subject { described_class.new }

    it "should be initialized with a 16 size array" do
      expect(subject.keyboard_register.size).to eq 16
    end

    shared_examples "emulating the the keyboards key pressed" do |keyboard_key, expected_pos|
      it "should return the expected Vposition #{expected_pos} as 1" do
        subject.press_key(keyboard_key)

        expect(subject.keyboard_register[expected_pos]).to eq 1
      end
    end

    shared_examples "emulating the the keyboards key released" do |keyboard_key, expected_pos|
      it "should return the expected Vposition #{expected_pos} as 0" do
        subject.release_key(keyboard_key)

        expect(subject.keyboard_register[expected_pos]).to eq 0
      end
    end

    describe "#map_keyboard_position" do
      include_examples "emulating the the keyboards key pressed", Gosu::KB_1, 0x1
      include_examples "emulating the the keyboards key pressed", Gosu::KB_2, 0x2
      include_examples "emulating the the keyboards key pressed", Gosu::KB_3, 0x3
      include_examples "emulating the the keyboards key pressed", Gosu::KB_4, 0xC
      include_examples "emulating the the keyboards key pressed", Gosu::KB_Q, 0x4
      include_examples "emulating the the keyboards key pressed", Gosu::KB_W, 0x5
      include_examples "emulating the the keyboards key pressed", Gosu::KB_E, 0x6
      include_examples "emulating the the keyboards key pressed", Gosu::KB_R, 0xD
      include_examples "emulating the the keyboards key pressed", Gosu::KB_A, 0x7
      include_examples "emulating the the keyboards key pressed", Gosu::KB_S, 0x8
      include_examples "emulating the the keyboards key pressed", Gosu::KB_D, 0x9
      include_examples "emulating the the keyboards key pressed", Gosu::KB_F, 0xE
      include_examples "emulating the the keyboards key pressed", Gosu::KB_Z, 0xA
      include_examples "emulating the the keyboards key pressed", Gosu::KB_X, 0x0
      include_examples "emulating the the keyboards key pressed", Gosu::KB_C, 0xB
      include_examples "emulating the the keyboards key pressed", Gosu::KB_V, 0xF

      include_examples "emulating the the keyboards key released", Gosu::KB_1, 0x1
      include_examples "emulating the the keyboards key released", Gosu::KB_2, 0x2
      include_examples "emulating the the keyboards key released", Gosu::KB_3, 0x3
      include_examples "emulating the the keyboards key released", Gosu::KB_4, 0xC
      include_examples "emulating the the keyboards key released", Gosu::KB_Q, 0x4
      include_examples "emulating the the keyboards key released", Gosu::KB_W, 0x5
      include_examples "emulating the the keyboards key released", Gosu::KB_E, 0x6
      include_examples "emulating the the keyboards key released", Gosu::KB_R, 0xD
      include_examples "emulating the the keyboards key released", Gosu::KB_A, 0x7
      include_examples "emulating the the keyboards key released", Gosu::KB_S, 0x8
      include_examples "emulating the the keyboards key released", Gosu::KB_D, 0x9
      include_examples "emulating the the keyboards key released", Gosu::KB_F, 0xE
      include_examples "emulating the the keyboards key released", Gosu::KB_Z, 0xA
      include_examples "emulating the the keyboards key released", Gosu::KB_X, 0x0
      include_examples "emulating the the keyboards key released", Gosu::KB_C, 0xB
      include_examples "emulating the the keyboards key released", Gosu::KB_V, 0xF
    end

    describe "#key_value" do
      it "should return the expected value from the pressed key" do
        keyboard_value = subject.key_value(Gosu::KB_1)
        keyboard_value2 = subject.key_value(Gosu::KB_4)
        keyboard_value3 = subject.key_value(Gosu::KB_V)

        expect(keyboard_value).to eq 0x1
        expect(keyboard_value2).to eq 0xC
        expect(keyboard_value3).to eq 0xF
      end
    end

    describe "#position_of_key_pressed" do
      it "should return the the position of the key pressed" do
        subject.instance_variable_set(:@keyboard_register, [0, 0, 0, 0, 1, 0, 0, 0])

        position = subject.position_of_key_pressed

        expect(position).to eq 0x4
      end
    end

    describe "#key_pressed?" do
      it "should return the the position of the key pressed if its pressed" do
        subject.instance_variable_set(:@keyboard_register, [0, 0, 0, 0, 0, 1, 0, 0])

        position = subject.key_pressed?(5)

        expect(position).to be_truthy
      end
    end
  end
end
