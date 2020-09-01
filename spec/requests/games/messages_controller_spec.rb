# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::MessagesController, type: :request do
  let(:user) { create(:user) }
  let(:game) { create(:game) }
  let(:headers) { { headers: { ACCEPT: 'application/json' } } }

  before { sign_in user }

  describe 'GET /games/:game_id/messages json' do
    before do
      create_list(:message, 21, game: game, user: user)

      get "/api/games/#{game.id}/messages", **headers
    end

    it 'correct json' do
      expect(response.status).to eq 200
      expect(json_data[:data].size).to eq 20
      expect(response).to match_json_schema('games/messages/index')
    end
  end
end
