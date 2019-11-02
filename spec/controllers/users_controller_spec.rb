# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in_user(user) }

  describe 'GET #current json' do
    context 'when get short info' do
      before { get :current, params: { full: false, format: :json } }

      it 'correct json' do
        expect(response.status).to eq 200
        expect(response).to match_json_schema('users/current_user_short')
      end
    end
  end
end
