# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Folders::Images::Create, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:folder) { create(:folder) }
  let(:file) { file_fixture('test.png') }

  describe 'create new image' do
    let(:input) do
      {
        folder_id: folder.id,
        file: Rack::Test::UploadedFile.new(file, 'image/png')
      }
    end

    it 'save new image' do
      expect(interactor).to be_success
      folder = interactor.success
      expect(folder.files.first.image).to be_attached
    end
  end
end
