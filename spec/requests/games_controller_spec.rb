# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GamesController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { { headers: { ACCEPT: 'application/json' } } }

  before { sign_in user }

  describe 'GET /games json' do
    let!(:game) do
      game = create(:game)
      game.update(users: [user])
      game
    end

    let!(:other_game) { create(:game) }
    let!(:master_game) { create(:game, master: user) }
    let!(:close_game) { create(:game, :close) }

    context 'when get open games' do
      before { get '/api/games', **headers, params: { open: true } }

      it 'correct json' do
        expect(response.status).to eq 200
        expect(response).to match_json_schema('games/index')
        expect(json_data.size).to eq 3
      end

      it 'correct order' do
        expect(json_data[0][:id]).to eq master_game.id
        expect(json_data[1][:id]).to eq game.id
        expect(json_data[2][:id]).to eq other_game.id
      end
    end

    context 'when get close games' do
      before { get '/api/games', **headers, params: { open: false } }

      it 'correct json' do
        expect(response.status).to eq 200
        expect(response).to match_json_schema('games/index')
        expect(json_data.size).to eq 1
      end

      it 'correct order' do
        expect(json_data[0][:id]).to eq close_game.id
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
