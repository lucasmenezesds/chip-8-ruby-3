# frozen_string_literal: true

RSpec.describe Menu do
  describe '#version' do
    it 'has a version number' do
      expect(Menu::VERSION).to eq("0.0.1")
    end
  end

  context 'Menu' do
    let(:roms_mock) { ['rom1.o'] }
    let(:prompt_double) { instance_double(Menu::Components::Prompt) }

    describe '#initialize' do
      it 'should call the method #define_flow' do
        expect_any_instance_of(Menu::Menu).to receive(:define_flow)
        Menu::Menu.new
      end
    end

    context 'when not using the ARGV params' do
      before do
        expect_any_instance_of(Menu::Menu).to receive(:define_flow)
      end

      let(:menu) { Menu::Menu.new }
      let(:roms) { %w(rom1.o rom2.ch8) }

      describe '#list_roms' do
        it 'should only return a list with files with ch8 and o extension' do
          expect(Dir).to receive(:entries).with('roms/').and_return(%w(. .. .gitignore rom.w rom1.o rom2.ch8))

          result = menu.send(:list_roms)

          expect(result).to eq(roms)
        end
      end

      describe '#show_roms' do
        it 'should only a selected value from #build_prompt' do
          prompt_double = instance_double(Menu::Components::Prompt)

          expect(menu).to receive(:list_roms).and_return(roms)
          expect(Menu::Components::Prompt).to receive(:new).and_return(prompt_double)
          expect(prompt_double).to receive(:build_prompt).and_return('rom1.o')

          result = menu.send(:show_roms)

          expect(result).to eq('rom1.o')
        end
      end
    end

    context 'when receiving the ARGV params' do
      describe '#valid_rom_name?' do
        before do
          expect_any_instance_of(Menu::Menu).to receive(:define_flow)
        end

        context 'when the rom_name is nil' do
          it 'should call #abort' do
            expected_message = "== Please tell me which rom you want to play! =="
            menu_with_params = Menu::Menu.new(debug_flag: '0')

            expect do
              expect { menu_with_params.send(:valid_rom_name?) }.to raise_error(SystemExit, expected_message)
            end.to output.to_stderr
          end
        end

        context 'when the file on rom_name is not from the accepted file extensions' do
          it 'should call #abort' do
            expected_message = "== Please tell me which rom you want to play! =="
            menu_with_params = Menu::Menu.new(debug_flag: '0', rom_name: 'wrong_rom.xyz')

            expect do
              expect { menu_with_params.send(:valid_rom_name?) }.to raise_error(SystemExit, expected_message)
            end.to output.to_stderr
          end
        end

        context 'when the rom_name is correct' do
          it 'should not raise any error or message' do
            menu_with_params = Menu::Menu.new(debug_flag: '0', rom_name: 'wrong_rom.o')

            expect { menu_with_params.send(:valid_rom_name?) }.not_to raise_error
          end
        end
      end

      describe '#valid_rom_name?' do
        before do
          expect_any_instance_of(Menu::Menu).to receive(:define_flow)
        end

        context 'when the rom_name is nil' do
          it 'should call #abort' do
            expect($STEP_BY_STEP_FLAG).to be_falsey
            expect($DEBUG_FLAG).to be_falsey

            menu_with_params = Menu::Menu.new(debug_flag: '1', rom_name: 'wrong_rom.o')
            menu_with_params.send(:set_debug_flags)

            expect($STEP_BY_STEP_FLAG).to eq(false)
            expect($DEBUG_FLAG).to eq(true)
          end
        end
      end

    end

    describe '#define_flow?' do
      context 'when the debug_flag is not sent' do
        it 'should call #show_roms' do
          expect_any_instance_of(Menu::Menu).not_to receive(:set_debug_flags)
          expect_any_instance_of(Menu::Menu).not_to receive(:valid_rom_name?)
          expect_any_instance_of(Menu::Menu).to receive(:show_roms).and_return('rom.tst')

          menu_instance = Menu::Menu.new

          expect(menu_instance.selected_rom).to eq('rom.tst')
        end
      end

      context 'when the debug_flag IS sent correctly' do
        it 'should call #set_debug_flags and #valid_rom_name?' do
          expect_any_instance_of(Menu::Menu).not_to receive(:show_roms)
          expect_any_instance_of(Menu::Menu).to receive(:set_debug_flags)
          expect_any_instance_of(Menu::Menu).to receive(:valid_rom_name?)

          menu_instance = Menu::Menu.new(debug_flag: '1', rom_name: 'rom.o')

          expect(menu_instance.selected_rom).to eq('rom.o')
        end
      end
    end
  end
end
