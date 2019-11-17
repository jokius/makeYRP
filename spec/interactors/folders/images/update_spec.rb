# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Folders::Images::Update, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  describe 'update image' do
    let(:image) { create(:folder_file, name: 'old name') }
    let(:input) do
      {
        id: image.id,
        name: 'super name'
      }
    end

    it 'name changed' do
      expect(interactor.success.name).to eq input[:name]
    end
  end
end
