# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Folders::Update, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  describe 'create new folder' do
    let(:folder) { create(:folder, name: 'old name') }
    let(:input) do
      {
        id: folder.id,
        name: 'super name'
      }
    end

    it 'save new folder' do
      expect(interactor.success.name).to eq input[:name]
    end
  end
end
