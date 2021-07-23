# frozen_string_literal: true

describe Chip8::Components::Clock do
  context "#initialize" do
    subject { described_class.new }
    it "should initialize with the expecting data" do
      clock_hz = subject.instance_variable_get(:@clock_hz)
      expect(clock_hz).to eq 60
      expect(subject.cpu_clock).to eq 0.016666666666666666
      expect(subject.delay_timer).to eq 0xFF
      expect(subject.sound_timer).to eq 0xFF
    end
  end

  context "#update" do
    it "should call the update for delay and sound timer" do
      expect(subject).to receive(:update_delay_timer).exactly(1)
      expect(subject).to receive(:update_sound_timer).exactly(1)
      subject.update
    end
  end

  context "#set_delay_timer" do
    it "should update the value for delay timer" do
      subject.set_delay_timer(0xF)

      expect(subject.delay_timer).to eq(0xF)
    end

    it "should raise an argument error if new_value > 0xFF" do
      expect { subject.set_delay_timer(0xFF1) }.to raise_error(ArgumentError)
    end
  end

  context "#set_sound_timer" do
    it "should update the value for sound timer" do
      subject.set_sound_timer(0xFA)

      expect(subject.sound_timer).to eq(0xFA)
    end

    it "should raise an argument error if new_value > 0xFF" do
      expect { subject.set_sound_timer(0xFF2) }.to raise_error(ArgumentError)
    end
  end

  context "#update_delay_timer" do
    it "should reduce the value of delay timer" do
      subject.set_delay_timer(0xFA)

      subject.update_delay_timer

      expect(subject.delay_timer).to eq(0xF9)
    end

    it "should not reduce the value of delay timer to a negative value" do
      subject.set_delay_timer(0x0)

      subject.update_delay_timer

      expect(subject.delay_timer).to eq(0x0)
    end
  end

  context "#update_sound_timer" do
    it "should reduce the value of sound timer" do
      subject.set_sound_timer(0xF1)

      subject.update_sound_timer

      expect(subject.sound_timer).to eq(0xF0)
    end

    it "should not reduce the value of sound timer to a negative value" do
      subject.set_sound_timer(0x0)

      subject.update_sound_timer

      expect(subject.sound_timer).to eq(0x0)
    end
  end

  context "#increase_cpu_clock" do
    it "should increase the cpu clock by 20Hz" do
      expect(subject).to receive(:puts).once

      subject.increase_cpu_clock
      clock_hz = subject.instance_variable_get(:@clock_hz)

      expect(clock_hz).to eq 80
    end
  end
  context "#decrease_cpu_clock" do
    it "should decrease the cpu clock by 20Hz" do
      expect(subject).to receive(:puts).once

      subject.decrease_cpu_clock
      clock_hz = subject.instance_variable_get(:@clock_hz)

      expect(clock_hz).to eq 40
    end

    it "should not decrease the cpu clock if the current clock is 20Hz" do
      subject.instance_variable_set(:@clock_hz, 20)
      subject.decrease_cpu_clock
      clock_hz = subject.instance_variable_get(:@clock_hz)

      expect(clock_hz).to eq 20
    end
  end
  context "#reset_cpu_clock" do
    it "should reset the cpu clock to 60Hz" do
      expect(subject).to receive(:puts).once

      subject.reset_cpu_clock
      clock_hz = subject.instance_variable_get(:@clock_hz)

      expect(clock_hz).to eq 60
    end
  end
end
