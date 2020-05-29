# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FoldersController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { { headers: { ACCEPT: 'application/json' } } }

  before { sign_in user }

  describe 'POST /folder json' do
    before do
      post '/api/folder',
           **headers,
           params: {
             name: 'new folder',
             parent_id: nil
           }
    end

    it 'correct json' do
      expect(response.status).to eq 201
      expect(response).to match_json_schema('folders/show')
    end
  end

  describe 'GET /folder json' do
    context 'when root' do
      before { get '/api/folder', **headers }

      it 'correct json' do
        expect(response.status).to eq 200
        expect(response).to match_json_schema('folders/show')
      end
    end

    context 'when by id' do
      before { get '/api/folder', **headers, params: { id: create(:folder).id } }

      it 'correct json' do
        expect(response.status).to eq 200
        expect(response).to match_json_schema('folders/show')
      end
    end
  end

  describe 'PUT /folders/:id json' do
    let(:folder) { create(:folder) }
    let(:new_name) { 'new folder' }

    before do
      put "/api/folders/#{folder.id}",
          **headers,
          params: {
            name: new_name
          }
    end

    it 'correct json' do
      expect(response.status).to eq 201
      expect(json_data[:name]).to eq new_name
      expect(response).to match_json_schema('folders/show')
    end
  end

  describe 'DELETE /folders/:id json' do
    before { delete "/api/folders/#{create(:folder).id}", **headers }

    it { expect(response.status).to eq 204 }
  end
end
