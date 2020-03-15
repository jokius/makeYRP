# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameChannel, type: :channel do
  let(:channel) { class_double(described_class).as_stubbed_const(transfer_nested_constants: true) }
  let(:user) { create(:user) }
  let(:game) { create(:game) }

  before do
    stub_connection current_user: user
    subscribe(game_id: game.id)
  end

  it '#subscribe' do
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_for(game)
  end

  describe '#add' do
    it 'sheet' do
      params = { game_id: game.id, sheet_type: 'character', 'type' => 'sheet' }
      expect { subscription.add(params) }.to(have_broadcasted_to(game).with do |data|
        expect(data[:sheet]).to match_json_schema('sheets/show')
        expect(data[:new]).to be true
      end)

      sheet = Sheet.find_by(game: game, owner: user)
      expect(sheet).not_to be_nil
    end

    it 'errors' do
      allow(channel).to receive(:broadcast_to).with(game, errors: anything)
      subscription.add({})
    end
  end

  describe '#change' do
    describe 'sheet' do
      let(:sheet) { create(:sheet) }
      let(:new_name) { 'super name' }
      let(:sheet_params) { { 'new_params' => 'updated' } }
      let(:params) { { id: sheet.id, name: new_name, params: sheet_params, 'type' => 'sheet' } }

      it 'broadcasted to game' do
        expect { subscription.change(params) }.to(have_broadcasted_to(game).with do |data|
          expect(data[:sheet]).to match_json_schema('sheets/show')
          expect(data[:update]).to be true
        end)
      end

      it 'broadcasted to sheet' do
        expect { subscription.change(params) }.to(have_broadcasted_to(sheet).from_channel(SheetChannel).with do |data|
          expect(data).to match_json_schema('sheets/show')
        end)
      end

      it 'new params save' do
        subscription.change(params)
        sheet.reload
        expect(sheet.name).to eq new_name
        expect(sheet.params).to eq sheet_params
      end
    end

    it 'errors' do
      allow(channel).to receive(:broadcast_to).with(game, errors: anything)
      subscription.change({})
    end
  end

  describe '#remove' do
    describe 'sheet' do
      it 'broadcasted to game' do
        sheet = create(:sheet)
        params = { 'id' => sheet.id, 'type' => 'sheet' }
        expect { subscription.remove(params) }.to(have_broadcasted_to(game).with do |data|
          expect(data[:sheet]).to eq sheet.id
          expect(data[:delete]).to be true
        end)
      end

      it 'broadcasted to sheet' do
        sheet = create(:sheet)
        params = { 'id' => sheet.id, 'type' => 'sheet' }
        expect { subscription.remove(params) }.to(have_broadcasted_to(sheet).from_channel(SheetChannel).with do |data|
          expect(data[:delete]).to eq sheet.id
        end)
      end

      it 'remove record' do
        sheet = create(:sheet)
        params = { 'id' => sheet.id, 'type' => 'sheet' }
        subscription.remove(params)
        expect(Sheet.find_by(id: sheet.id)).to be_nil
      end
    end

    it 'errors' do
      allow(channel).to receive(:broadcast_to).with(game, errors: anything)
      subscription.change({})
    end
  end
end
