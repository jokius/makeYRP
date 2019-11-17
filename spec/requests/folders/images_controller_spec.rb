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
      post "/folders/#{folder.id}/images",
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
end
