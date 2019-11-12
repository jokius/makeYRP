# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FoldersController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { { headers: { ACCEPT: 'application/json' } } }

  before { sign_in user }

  describe 'POST /folder json' do
    before do
      post '/folder',
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
      before { get '/folder', **headers }

      it 'correct json' do
        expect(response.status).to eq 200
        expect(response).to match_json_schema('folders/show')
      end
    end

    context 'when by id' do
      before { get '/folder', **headers, params: { id: create(:folder).id } }

      it 'correct json' do
        expect(response.status).to eq 200
        expect(response).to match_json_schema('folders/show')
      end
    end
  end

  describe 'PUT /folder json' do
    let(:folder) { create(:folder) }
    let(:new_name) { 'new folder' }

    before do
      put '/folder',
          **headers,
          params: {
            id: folder.id,
            name: new_name
          }
    end

    it 'correct json' do
      expect(response.status).to eq 201
      expect(json_data[:name]).to eq new_name
      expect(response).to match_json_schema('folders/show')
    end
  end

  describe 'DELETE /folder json' do
    before { delete '/folder', **headers, params: { id: create(:folder).id } }

    it { expect(response.status).to eq 204 }
  end
end
