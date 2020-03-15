# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::SheetsController, type: :request do
  let(:user) { create(:user) }
  let(:game) { create(:game) }
  let(:headers) { { headers: { ACCEPT: 'application/json' } } }

  before { sign_in user }

  describe 'GET /games/:game_id/sheets json' do
    before do
      create(:sheet, game: game, owner: user)
      get "/games/#{game.id}/sheets", **headers
    end

    it 'correct json' do
      expect(response.status).to eq 200
      expect(response).to match_json_schema('sheets/index')
    end
  end
end
