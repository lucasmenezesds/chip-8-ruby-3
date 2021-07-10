# frozen_string_literal: true

RSpec.describe Chip8 do
  it "has a version number" do
    expect(Chip8::VERSION).not_to be nil
  end
end
