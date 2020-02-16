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
    it 'matches with sheet' do
      expect { create_sheet }.to have_broadcasted_to(game).from_channel(GameChannel).with do |data|
        expect(data[:sheet]).to match_json_schema('sheets/show')
        expect(data[:new]).to be true
      end
    end
  end

  describe 'PUT /games/:game_id/sheets json' do
    let(:sheet) { create(:sheet, game: game, owner: user) }

    it 'matches with sheet' do
      expect { update_sheet(sheet.id) }.to have_broadcasted_to(sheet).from_channel(SheetChannel).with do |data|
        expect(data).to match_json_schema('sheets/show')
      end

      expect { update_sheet(sheet.id) }.to have_broadcasted_to(game).from_channel(GameChannel).with do |data|
        expect(data[:sheet]).to match_json_schema('sheets/show')
        expect(data[:update]).to be true
      end
    end
  end

  describe 'DELETE /games/:game_id/sheets/:id json' do
    let(:sheet_1) { create(:sheet, game: game, owner: user) }
    let(:sheet_2) { create(:sheet, game: game, owner: user) }

    it 'is send delete' do
      expect { delete_sheet(game.id, sheet_1.id) }
        .to have_broadcasted_to(sheet_1).from_channel(SheetChannel).with do |data|
        expect(data[:delete]).to eq sheet_1.id
      end

      expect { delete_sheet(game.id, sheet_2.id) }
        .to have_broadcasted_to(game).from_channel(GameChannel).with do |data|
        expect(data[:sheet]).to eq sheet_2.id
        expect(data[:delete]).to be true
      end
    end
  end

  private

  def create_sheet
    game_id = game.id
    post "/games/#{game_id}/sheets",
         **headers,
         params: {
           game_id: game_id,
           sheet_type: 'character'
         }
  end

  def update_sheet(id)
    put("/games/#{game.id}/sheets/#{id}",
        **headers,
        params: {
          name: 'super name',
          params: { new_params: 'updated' }
        })
  end

  def delete_sheet(game_id, id)
    delete "/games/#{game_id}/sheets/#{id}", **headers
  end
end
