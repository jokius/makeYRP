# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Folders::Create, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:user) { create(:user) }

  describe 'create new folder' do
    context 'when root folder' do
      let(:input) do
        {
          user_id: user.id,
          name: 'super name',
          parent_id: nil
        }
      end

      it 'save new folder' do
        folder = interactor.success
        expect(folder.name).to eq input[:name]
        expect(folder.user_id).to eq user.id
        expect(folder.parent_id).to eq user.folders.root.id
      end
    end

    context 'when nested folder' do
      let(:parent) { create(:folder) }

      let(:input) do
        {
          user_id: user.id,
          name: 'super name',
          parent_id: parent.id
        }
      end

      it 'save new folder' do
        folder = interactor.success
        expect(folder.name).to eq input[:name]
        expect(folder.user_id).to eq user.id
        expect(folder.parent_id).to eq parent.id
      end
    end
  end
end
