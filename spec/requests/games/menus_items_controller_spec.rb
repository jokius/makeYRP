# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::MenusItemsController, type: :request do
  let(:user) { create(:user) }
  let(:game) { create(:game) }
  let(:menu) { create(:menu, game: game) }
  let(:headers) { { headers: { ACCEPT: 'application/json' } } }

  before { sign_in user }

  describe 'POST /games/:game_id/menus_items json' do
    it 'matches with menu_item' do
      expect { create_item }.to have_broadcasted_to(game).from_channel(MenusItemsChannel).with do |data|
        expect(data).to match_json_schema('games/menus/items/show')
      end
    end
  end

  describe 'PUT /games/:game_id/menus_items json' do
    let(:item) { create(:menus_item) }

    it 'matches with menu_item' do
      expect { update_item(item.id) }.to have_broadcasted_to(item).from_channel(MenusItemChannel).with do |data|
        expect(data).to match_json_schema('games/menus/items/show')
      end
    end
  end

  describe 'DELETE /games/:game_id/sheets/:id json' do
    let(:item) { create(:menus_item) }

    it 'is send delete' do
      expect { delete_item(item.id) }.to have_broadcasted_to(item).from_channel(MenusItemChannel).with do |data|
        expect(data).to match(id: item.id, menu_id: item.menu_id)
      end
    end
  end

  private

  def create_item
    game_id = game.id
    post "/games/#{game_id}/menus_items.json",
         params: {
           menu_id: menu.id,
           params: { name: 'test' }
         }
  end

  def update_item(id)
    put("/games/0/menus_items/#{id}",
        **headers,
        params: {
          params: { new_params: 'updated' }
        })
  end

  def delete_item(id)
    delete "/games/0/menus_items/#{id}", **headers
  end
end
