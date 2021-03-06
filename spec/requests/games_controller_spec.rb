# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GamesController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { { headers: { ACCEPT: 'application/json' } } }

  before { sign_in user }

  describe 'GET /games json' do
    let!(:close_game) do
      game = create(:game, :close)
      game.users << user
      game
    end

    before do
      game = create(:game)
      game.users << user
      game = create(:game)
      game.users << user
      game = create(:game, master: user)
      game.users << create(:user)
    end

    context 'when get open games' do
      before { get '/api/games', **headers, params: { open: true } }

      it 'correct json' do
        expect(response.status).to eq 200
        expect(response).to match_json_schema('games/index')
        expect(json_data[:data].size).to eq 3
      end
    end

    context 'when get close games' do
      before { get '/api/games', **headers, params: { open: false } }

      it 'correct json' do
        expect(response.status).to eq 200
        expect(response).to match_json_schema('games/index')
        expect(json_data[:data].size).to eq 1
      end

      it 'correct order' do
        expect(json_data[:data][0][:id]).to eq close_game.id.to_s
      end
    end
  end

  describe 'POST /games json' do
    let(:system) { create :system }

    before do
      post '/api/games',
           **headers,
           params: {
             name: 'new game',
             system_id: system.id
           }
    end

    it 'correct json' do
      expect(response.status).to eq 201
      expect(json_data[:id]).not_to be_nil
    end
  end

  describe 'POST /games/:id/join json' do
    let(:game) { create :game }

    before do
      post "/api/games/#{game.id}/join", **headers
    end

    it 'correct json' do
      expect(response.status).to eq 201
      expect(json_data[:id]).not_to be_nil
    end
  end

  describe 'GET /games/:id json' do
    let(:game) { create(:game) }

    before { get "/api/games/#{game.id}", **headers }

    it 'correct json' do
      expect(response.status).to eq 200
      expect(response).to match_json_schema('games/show')
    end
  end

  describe 'PUT /games/:id/switch_status' do
    let(:game) { create(:game, master: user, open: true) }

    before { put "/api/games/#{game.id}/switch_status", **headers }

    it 'correct json' do
      expect(response.status).to eq 204
      expect(game.reload.open).to be false
    end
  end
end
