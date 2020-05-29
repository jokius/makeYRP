# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::GamesController, type: :request do
  let(:user) { create(:admin) }
  let(:headers) { { headers: { ACCEPT: 'application/json' } } }

  before { sign_in user }

  describe 'GET /admin/games json' do
    before do
      create(:game)
      get '/api/admin/games', **headers, params: { open: true }
    end

    it 'correct json' do
      expect(response.status).to eq 200
      expect(response).to match_json_schema('games/index')
      expect(json_data.size).to eq 1
    end
  end

  describe 'DELETE /admin/games/:id' do
    let(:game) { create(:game) }

    before { delete "/api/admin/games/#{game.id}", **headers }

    it 'correct json' do
      expect(response.status).to eq 204
      expect(Game.find_by(id: game.id)).to be_nil
    end
  end
end
