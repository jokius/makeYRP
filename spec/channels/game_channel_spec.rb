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

    it 'page' do
      params = { game_id: game.id, name: 'test', 'type' => 'page' }
      expect { subscription.add(params) }.to(have_broadcasted_to(game).with do |data|
        expect(data[:page]).to match_json_schema('games/pages/show')
        expect(data[:new]).to be true
      end)

      page = Page.find_by(game: game, name: 'test')
      expect(page).not_to be_nil
    end

    it 'message' do
      params = { game_id: game.id, body: { text: 'test' }, 'type' => 'message' }
      expect { subscription.add(params) }.to(have_broadcasted_to(game).with do |data|
        expect(data[:message]).to match_json_schema('games/messages/show')
        expect(data[:new]).to be true
      end)

      message = Message.find_by(game: game, user: user)
      expect(message).not_to be_nil
    end

    it 'menu_item' do
      menu = create(:menu)
      params = { game_id: game.id, menu_id: menu.id, params: { test: 'new' }, 'type' => 'menu_item' }
      expect { subscription.add(params) }.to(have_broadcasted_to(game).with do |data|
        expect(data[:menu_item]).to match_json_schema('games/menus/items/show')
        expect(data[:new]).to be true
      end)

      menu_item = Menus::Item.find_by(menu: menu)
      expect(menu_item).not_to be_nil
    end

    it 'errors' do
      allow(channel).to receive(:broadcast_to).with(game, errors: anything)
      subscription.add({})
    end
  end

  describe '#change' do
    describe 'sheet' do
      let(:sheet) { create(:sheet, owner: user) }
      let(:new_name) { 'super name' }
      let(:sheet_params) { { 'new_params' => 'updated' } }
      let(:params) { { 'id' => sheet.id, name: new_name, params: sheet_params, 'type' => 'sheet' } }

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

    describe 'page' do
      let(:page) { create(:page) }
      let(:new_name) { 'new page name' }
      let(:page_params) { { 'new_params' => 'updated' } }
      let(:params) { { id: page.id, name: new_name, page_params: page_params, 'type' => 'page' } }

      it 'broadcasted to game' do
        expect { subscription.change(params) }.to(have_broadcasted_to(game).with do |data|
          expect(data[:page]).to match_json_schema('games/pages/show')
          expect(data[:update]).to be true
        end)
      end

      it 'new params save' do
        subscription.change(params)
        page.reload
        expect(page.name).to eq new_name
        expect(page.params).to eq page_params
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
        sheet = create(:sheet, owner: user)
        params = { 'id' => sheet.id, 'type' => 'sheet' }
        expect { subscription.remove(params) }.to(have_broadcasted_to(game).with do |data|
          expect(data[:sheet]).to eq sheet.id
          expect(data[:delete]).to be true
        end)
      end

      it 'broadcasted to sheet' do
        sheet = create(:sheet, owner: user)
        params = { 'id' => sheet.id, 'type' => 'sheet' }
        expect { subscription.remove(params) }.to(have_broadcasted_to(sheet).from_channel(SheetChannel).with do |data|
          expect(data[:delete]).to eq sheet.id
        end)
      end

      it 'remove record' do
        sheet = create(:sheet, owner: user)
        params = { 'id' => sheet.id, 'type' => 'sheet' }
        subscription.remove(params)
        expect(Sheet.find_by(id: sheet.id)).to be_nil
      end
    end

    describe 'page' do
      it 'broadcasted to game' do
        page = create(:page)
        params = { 'id' => page.id, 'type' => 'page' }
        expect { subscription.remove(params) }.to(have_broadcasted_to(game).with do |data|
          expect(data[:page]).to eq page.id
          expect(data[:delete]).to be true
        end)
      end

      it 'remove record' do
        page = create(:page)
        params = { 'id' => page.id, 'type' => 'page' }
        subscription.remove(params)
        expect(Page.find_by(id: page.id)).to be_nil
      end
    end

    it 'errors' do
      allow(channel).to receive(:broadcast_to).with(game, errors: anything)
      subscription.change({})
    end
  end
end
