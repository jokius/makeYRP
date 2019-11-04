# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SystemsController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { { headers: { ACCEPT: 'application/json' } } }

  before { sign_in user }

  describe 'GET /systems json' do
    before do
      create(:system)
      get '/systems', **headers
    end

    it 'correct json' do
      expect(response.status).to eq 200
      expect(response).to match_json_schema('systems/index')
    end
  end

  describe 'POST /systems json' do
    before do
      post '/systems',
           **headers,
           params: {
             name: 'new system',
             text: file_fixture('system.json').read,
             file: nil
           }
    end

    it { expect(response.status).to eq 204 }
    it { expect(System.find_by(name: 'new system')).not_to be_nil }
  end
end
