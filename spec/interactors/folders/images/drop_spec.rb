# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Folders::Images::Drop, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:user) { create(:user) }
  let(:page) { create(:page) }
  let(:file) { file_fixture('test.png') }

  describe 'create new image' do
    let(:input) do
      {
        user_id: user.id,
        page_id: page.id,
        x: 1,
        y: 1,
        file: Rack::Test::UploadedFile.new(file, 'image/png'),
        layer: 'players',
        rank: 1
      }
    end

    it 'save new image' do
      expect(interactor).to be_success
      image = interactor.success
      expect(image.page_id).to eq page.id
    end
  end
end
