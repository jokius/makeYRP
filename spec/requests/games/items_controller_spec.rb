# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::ItemsController, type: :request do
  let(:user) { create(:user) }
  let(:game) { create(:game) }
  let(:headers) { { headers: { ACCEPT: 'application/json' } } }

  before { sign_in user }

  describe 'GET /games/:game_id/items json' do
    before do
      create_list(:item, 2, game: game)

      get "/api/games/#{game.id}/items", **headers
    end

    it 'correct json' do
      expect(response.status).to eq 200
      expect(json_data.size).to eq 2
      expect(response).to match_json_schema('games/items/index')
    end
  end
end
