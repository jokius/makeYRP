# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Folders::ImagesController, type: :request do
  let(:user) { create(:user) }
  let(:folder) { create(:folder) }
  let(:headers) { { headers: { ACCEPT: 'application/json' } } }

  before { sign_in user }

  describe 'POST /folders/:folder_id/images json' do
    let(:file) { file_fixture('test.png') }

    before do
      post "/api/folders/#{folder.id}/images",
           **headers,
           params: {
             file: Rack::Test::UploadedFile.new(file, 'image/png')
           }
    end

    it 'correct json' do
      expect(response.status).to eq 201
      expect(response).to match_json_schema('folders/show')
    end
  end

  describe 'PUT /folders/:folder_id/images/:id json' do
    let(:image) { create(:folder_file) }
    let(:new_name) { 'new folder' }

    before do
      put "/api/folders/0/images/#{image.id}",
          **headers,
          params: {
            name: new_name
          }
    end

    it 'correct json' do
      expect(response.status).to eq 201
      expect(json_data[:name]).to eq new_name
      expect(response).to match_json_schema('folders/images/show')
    end
  end

  describe 'DELETE /folders/:folder_id/images/:id json' do
    let(:image) { create(:folder_file) }

    before { delete "/api/folders/0/images/#{image.id}", **headers }

    it { expect(response.status).to eq 204 }
  end
end
