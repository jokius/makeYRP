# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::ConfigsController, type: :request do
  let(:user) { create(:user) }
  let(:game) { create(:game, master: user) }
  let(:headers) { { headers: { ACCEPT: 'application/json' } } }

  before { sign_in user }

  describe 'GET /games/:game_id/config json' do
    before do
      get "/api/games/#{game.id}/config", **headers
    end

    it 'correct json' do
      expect(response.status).to eq 200
      expect(response).to match_json_schema('games/config/show')
    end
  end

  describe 'PUT /games/:game_id/config' do
    let(:params) { { name: 'new name', custom_template: {} } }

    before do
      put "/api/games/#{game.id}/config", params: params
    end

    it 'correct json' do
      expect(response.status).to eq 204
      expect(game.reload.name).to eq params[:name]
    end
  end
end
