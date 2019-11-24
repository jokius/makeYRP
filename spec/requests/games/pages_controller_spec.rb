# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::PagesController, type: :request do
  let(:user) { create(:user) }
  let(:game) { create(:game) }
  let(:headers) { { headers: { ACCEPT: 'application/json' } } }

  before { sign_in user }

  describe 'POST /games/:game_id/pages json' do
    before do
      post "/games/#{game.id}/pages",
           **headers,
           params: {
             game_id: game.id,
             name: 'test page'
           }
    end

    it { expect(response.status).to eq 201 }
    it { expect(Page.find_by(game: game, name: 'test page')).not_to be_nil }
  end

  describe 'PUT /games/:game_id/pages/:id json' do
    let(:page) { create(:page) }
    let(:new_name) { 'new page name' }
    let(:page_params) { { test_key: 'test' } }

    before do
      put "/games/0/pages/#{page.id}",
          **headers,
          params: {
            name: new_name,
            page_params: page_params
          }
    end

    it 'correct json' do
      expect(response.status).to eq 201
      expect(response).to match_json_schema('games/pages/show')
    end
  end

  describe 'DELETE /games/:game_id/pages/:id json' do
    let(:page) { create(:page) }

    before do
      delete "/games/0/pages/#{page.id}", **headers
    end

    it { expect(response.status).to eq 204 }
    it { expect(Page.find_by(id: page.id)).to be_nil }
  end
end
