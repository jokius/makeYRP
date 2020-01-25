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

  private

  def create_item
    game_id = game.id
    post "/games/#{game_id}/menus_items.json",
         params: {
           type: menu.identifier,
           params: { name: 'test' }
         }
  end
end
