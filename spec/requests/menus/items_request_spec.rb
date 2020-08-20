# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Menus::Items', type: :request do
  let(:user) { create(:user) }
  let(:menu) { create(:menu, game: create(:game)) }
  let(:headers) { { headers: { ACCEPT: 'application/json' } } }

  before { sign_in user }

  describe 'GET /menu/:menu_id/items json' do
    context 'when owner' do
      before do
        create(:menus_item, menu: menu, owner: user)
        create(:menus_item)
        get "/api/menu/#{menu.id}/items", **headers
      end

      it 'correct json' do
        expect(response.status).to eq 200
        expect(response).to match_json_schema('menu/items/index')
        expect(json_data.size).to eq 1
      end
    end

    context 'when change access' do
      before do
        item = create(:menus_item, menu: menu)
        create(:access_level, user: user, object: item, write: true)
        create(:menus_item)
        get "/api/menu/#{menu.id}/items", **headers
      end

      it 'correct json' do
        expect(response.status).to eq 200
        expect(response).to match_json_schema('menu/items/index')
        expect(json_data.size).to eq 1
      end
    end

    context 'when view access' do
      before do
        item = create(:menus_item, menu: menu)
        create(:access_level, user: user, object: item, read: true)
        create(:menus_item)
        get "/api/menu/#{menu.id}/items", **headers
      end

      it 'correct json' do
        expect(response.status).to eq 200
        expect(response).to match_json_schema('menu/items/index')
        expect(json_data.size).to eq 1
      end
    end
  end
end
