# frozen_string_literal: true

require 'rspec'

describe Menu::Components::Prompt do
  context 'when the rom_list is not empty' do
    before do
      tty_prompt_double = instance_double(TTY::Prompt)
      expect(TTY::Prompt).to receive(:new).with(help_color: :cyan).and_return(tty_prompt_double)
    end

    let(:rom_list) { %w[rom1.ch8 rom2.o] }
    let(:prompt_with_data) { described_class.new(rom_list: rom_list) }

    describe "#build_prompt" do
      it 'should call the #select method from TTY::Prompt' do
        prompt_instance_var = prompt_with_data.instance_variable_get(:@prompt)

        expect(prompt_instance_var).to receive(:select).with("Select the rom you want to load", rom_list)

        prompt_with_data.build_prompt
      end
    end
  end

  context 'when the rom_list IS empty' do
    let(:prompt_without_data) { described_class.new(rom_list: []) }

    describe "#build_prompt" do
      it 'should be aborted' do
        expected_message = "== Please put some roms in the roms folder and try again =="
        expect do
          expect { prompt_without_data.build_prompt }.to raise_error(SystemExit, expected_message)
        end.to output.to_stderr
      end
    end
  end
end
