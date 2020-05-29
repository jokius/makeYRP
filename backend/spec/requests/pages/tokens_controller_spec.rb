# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pages::TokensController, type: :request do
  let(:user) { create(:user) }
  let(:page) { create(:page) }
  let(:headers) { { headers: { ACCEPT: 'application/json' } } }

  before { sign_in user }

  describe 'GET /pages/:page_id/tokens json' do
    before do
      create(:token, page: page)
      get "/api/pages/#{page.id}/tokens", **headers
    end

    it 'correct json' do
      expect(response.status).to eq 200
      expect(response).to match_json_schema('tokens/index')
    end
  end
end
