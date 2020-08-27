# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Menus::FoldersController, type: :request do
  let(:user) { create(:user) }
  let(:menu) { create(:menu, game: create(:game)) }
  let(:headers) { { headers: { ACCEPT: 'application/json' } } }

  before { sign_in user }

  describe 'GET /menu/:menu_id/folders json' do
    context 'when owner' do
      before do
        create(:menus_item, menu: menu, owner: user, folder: menu.folders.root)
        create(:menus_item)
        get "/api/menu/#{menu.id}/folders", **headers
      end

      it 'correct json' do
        expect(response.status).to eq 200
        expect(response).to match_json_schema('menu/folder/show')
      end
    end

    context 'when change access' do
      before do
        item = create(:menus_item, menu: menu, folder: menu.folders.root)
        create(:access_level, user: user, object: item, write: true)
        create(:menus_item)
        get "/api/menu/#{menu.id}/folders", **headers
      end

      it 'correct json' do
        expect(response.status).to eq 200
        expect(response).to match_json_schema('menu/folder/show')
      end
    end

    context 'when view access' do
      before do
        item = create(:menus_item, menu: menu, folder: menu.folders.root)
        create(:access_level, user: user, object: item, read: true)
        create(:menus_item)
        get "/api/menu/#{menu.id}/folders", **headers
      end

      it 'correct json' do
        expect(response.status).to eq 200
        expect(response).to match_json_schema('menu/folder/show')
      end
    end
  end
end
