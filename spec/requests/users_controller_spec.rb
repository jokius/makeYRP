# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { { headers: { ACCEPT: 'application/json' } } }

  before { sign_in user }

  describe 'GET /users/current json' do
    context 'when get short info' do
      before do
        get '/api/users/current', **headers, params: { full: false }
      end

      it 'correct json' do
        expect(response.status).to eq 200
        expect(response).to match_json_schema('users/current_user_short')
      end
    end
  end
end
