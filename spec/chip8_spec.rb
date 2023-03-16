# frozen_string_literal: true

RSpec.describe Chip8 do
  describe "#version" do
    it "has a version number" do
      expect(Chip8::VERSION).to eq("0.0.2")
    end
  end
end
