# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::UsersController, type: :request do
  let(:user) { create(:user) }
  let(:game) { create(:game) }
  let(:headers) { { headers: { ACCEPT: 'application/json' } } }

  before { sign_in user }

  describe 'GET /games/:game_id/messages json' do
    before do
      REDIS.set("game_#{game.id}_user_#{user.id}", user.id.to_s)
      other_user = create(:user)
      REDIS.set("game_#{game.id}_user_#{other_user.id}", other_user.id.to_s)

      get "/api/games/#{game.id}/users", **headers
    end

    it 'correct json' do
      expect(response.status).to eq 200
      expect(json_data[:data].size).to eq 2
      expect(response).to match_json_schema('games/users/index')
    end
  end
end
