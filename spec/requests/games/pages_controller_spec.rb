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

  describe 'DELETE /games/:game_id/sheets/:id json' do
    let(:page) { create(:page, game: game) }

    before do
      delete "/games/#{game.id}/pages/#{page.id}", **headers
    end

    it { expect(response.status).to eq 204 }
    it { expect(Page.find_by(id: page.id)).to be_nil }
  end
end
