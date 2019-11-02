# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in_user(user) }

  describe 'GET #index json' do
    let!(:game) do
      game = create(:game)
      game.update(users: [user])
      game
    end

    let!(:other_game) { create(:game) }
    let!(:master_game) { create(:game, master: user) }
    let!(:close_game) { create(:game, :close) }

    context 'when get open games' do
      before { get :index, params: { open: true, format: :json } }

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
      before { get :index, params: { open: false, format: :json } }

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

  describe 'POST #create json' do
    let(:system) { create :system }

    before do
      post :create,
           params: {
             format: :json,
             name: 'new game',
             system_id: system.id
           }
    end

    it 'correct json' do
      expect(response.status).to eq 201
      expect(json_data[:id]).not_to be_nil
    end
  end

  describe 'GET #show json' do
    let(:game) { create(:game) }

    before { get :show, params: { id: game.id, format: :json } }

    it 'correct json' do
      expect(response.status).to eq 200
      expect(response).to match_json_schema('games/show')
    end
  end
end
