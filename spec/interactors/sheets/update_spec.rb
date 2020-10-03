# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sheets::Update, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:sheet) { create(:sheet) }

  describe 'update sheet' do
    context 'with name' do
      let(:input) do
        { id: sheet.id,
          name: 'super name',
          params: { 'new_params' => 'updated' },
          folder_id: sheet.folder.id }
      end

      it 'save new sheet' do
        sheet = interactor.success
        expect(sheet.name).to eq input[:name]
        expect(sheet.params).to match input[:params]
      end
    end
  end
end
