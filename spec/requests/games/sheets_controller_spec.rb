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

  describe 'POST /games/:game_id/sheets json' do
    before do
      post "/games/#{game.id}/sheets",
           **headers,
           params: {
             game_id: game.id,
             sheet_type: 'character'
           }
    end

    it { expect(response.status).to eq 201 }
    it { expect(Sheet.find_by(game: game, owner: user)).not_to be_nil }
  end

  describe 'PUT /games/:game_id/sheets json' do
    let(:sheet) { create(:sheet, game: game, owner: user) }

    before do
      put "/games/0/sheets/#{sheet.id}",
          **headers,
          params: {
            name: 'super name',
            params: { new_params: 'updated' }
          }
    end

    it 'correct json' do
      expect(response.status).to eq 201
      expect(response).to match_json_schema('sheets/show')
    end
  end

  describe 'DELETE /games/:game_id/sheets/:id json' do
    let(:sheet) { create(:sheet, game: game, owner: user) }

    before do
      delete "/games/0/sheets/#{sheet.id}", **headers
    end

    it { expect(response.status).to eq 204 }
    it { expect(Sheet.find_by(id: sheet.id)).to be_nil }
  end
end
