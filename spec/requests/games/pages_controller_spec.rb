# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::PagesController, type: :request do
  let(:user) { create(:user) }
  let(:game) { create(:game) }
  let(:headers) { { headers: { ACCEPT: 'application/json' } } }

  before { sign_in user }

  describe 'POST /games/:game_id/pages json' do
    it 'matches with page' do
      expect { create_page }.to have_broadcasted_to(game).from_channel(GameChannel).with do |data|
        expect(data[:page]).to match_json_schema('pages/show')
        expect(data[:new]).to be true
      end
    end
  end

  describe 'PUT /games/:game_id/pages/:id json' do
    let(:page) { create(:page, game: game) }

    it 'matches with page' do
      expect { update_page(page.id) }.to have_broadcasted_to(game).from_channel(GameChannel).with do |data|
        expect(data[:page]).to match_json_schema('pages/show')
        expect(data[:update]).to be true
      end
    end
  end

  describe 'DELETE /games/:game_id/pages/:id json' do
    let(:page) { create(:page, game: game) }

    it 'is send delete' do
      expect { delete_page(page.id) }
        .to have_broadcasted_to(game).from_channel(GameChannel).with do |data|
        expect(data[:page]).to eq page.id
        expect(data[:delete]).to be true
      end
    end
  end

  private

  def create_page
    game_id = game.id
    post "/games/#{game_id}/pages",
         **headers,
         params: {
           game_id: game_id,
           name: 'test page'
         }
  end

  def update_page(id)
    put "/games/#{game.id}/pages/#{id}",
        **headers,
        params: {
          name: 'new page name',
          page_params: { test_key: 'test' }
        }
  end

  def delete_page(id)
    delete "/games/#{game.id}/pages/#{id}", **headers
  end
end
