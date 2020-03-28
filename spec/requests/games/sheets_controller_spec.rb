# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::SheetsController, type: :request do
  let(:user) { create(:user) }
  let(:game) { create(:game) }
  let(:headers) { { headers: { ACCEPT: 'application/json' } } }

  before { sign_in user }

  describe 'GET /games/:game_id/sheets json' do
    context 'when owner' do
      before do
        create(:sheet, game: game, owner: user)
        create(:sheet)
        get "/games/#{game.id}/sheets", **headers
      end

      it 'correct json' do
        expect(response.status).to eq 200
        expect(response).to match_json_schema('sheets/index')
        expect(json_data.size).to eq 1
      end
    end

    context 'when change access' do
      before do
        sheet = create(:sheet, game: game)
        create(:access_level, user: user, object: sheet, write: true)
        create(:sheet)
        get "/games/#{game.id}/sheets", **headers
      end

      it 'correct json' do
        expect(response.status).to eq 200
        expect(response).to match_json_schema('sheets/index')
        expect(json_data.size).to eq 1
      end
    end

    context 'when view access' do
      before do
        sheet = create(:sheet, game: game)
        create(:access_level, user: user, object: sheet, read: true)
        create(:sheet)
        get "/games/#{game.id}/sheets", **headers
      end

      it 'correct json' do
        expect(response.status).to eq 200
        expect(response).to match_json_schema('sheets/index')
        expect(json_data.size).to eq 1
      end
    end
  end
end
