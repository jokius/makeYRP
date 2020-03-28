# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AclsController, type: :request do
  let(:user) { create(:user) }
  let(:game) { create(:game) }
  let(:headers) { { headers: { ACCEPT: 'application/json' } } }

  before do
    sign_in user
    game.users << user
  end

  describe 'GET acl json' do
    context 'when sheet' do
      before do
        sheet = create(:sheet)
        get '/acl', **headers, params: { type: 'sheet', id: sheet.id }
      end

      it 'correct json' do
        expect(response.status).to eq 200
        expect(response).to match_json_schema('acls/index')
      end
    end
  end
end
