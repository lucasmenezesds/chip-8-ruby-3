# frozen_string_literal: true

describe Chip8::Components::CPUStatus do
  context "#stopped" do
    subject { described_class.new }
    it "should change @stopped to true" do
      allow(subject).to receive(:sleep)
      allow(subject).to receive(:puts)

      subject.stop_it

      expect(subject.stopped).to be_truthy
    end
  end
end
