# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pages::GraphicsController, type: :request do
  let(:user) { create(:user) }
  let(:page) { create(:page) }
  let(:headers) { { headers: { ACCEPT: 'application/json' } } }

  before { sign_in user }

  describe 'GET /pages/:page_id/graphics json' do
    before do
      create(:graphic, page: page)
      get "/api/pages/#{page.id}/graphics", **headers
    end

    it 'correct json' do
      expect(response.status).to eq 200
      expect(json_data[:data]).to be_any
      expect(response).to match_json_schema('pages/graphic/index')
    end
  end
end
