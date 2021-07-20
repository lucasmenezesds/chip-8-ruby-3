# frozen_string_literal: true

describe Chip8::Components::Stack do
  context "#push_data" do
    subject { described_class.new }

    it "should push the expected data into the stack" do
      subject.push_data(0xFFFF)
      subject.push_data(0xFFF1)

      stack_data = subject.instance_variable_get(:@data)

      expect(stack_data[0]).to eq 0xFFFF
      expect(stack_data[1]).to eq 0xFFF1
      expect(stack_data.size).to eq 2
    end
  end

  context "#pop_data" do
    subject { described_class.new }

    it "should push the expected data into the stack" do
      subject.push_data(0xFFFF)
      subject.push_data(0xFFF1)
      subject.push_data(0xFFF0)

      popped_data = subject.pop_data
      popped_data2 = subject.pop_data

      stack_data = subject.instance_variable_get(:@data)
      expect(popped_data).to eq 0xFFF0
      expect(popped_data2).to eq 0xFFF1
      expect(stack_data.size).to eq 1
    end
  end
end
