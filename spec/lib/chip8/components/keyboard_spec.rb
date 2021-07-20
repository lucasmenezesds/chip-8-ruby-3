# frozen_string_literal: true

require "gosu"

describe Chip8::Components::Keyboard do
  context "after initialized" do
    subject { described_class.new }

    shared_examples "emulating the the keyboards key pressed" do |keyboard_key, expected_pos|
      it "should return the expected Vposition #{expected_pos} as 1" do
        subject.key_pressed(keyboard_key)

        expect(subject.keyboard_register[expected_pos]).to eq 1
      end
    end

    shared_examples "emulating the the keyboards key released" do |keyboard_key, expected_pos|
      it "should return the expected Vposition #{expected_pos} as 0" do
        subject.key_released(keyboard_key)

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
  end
end
