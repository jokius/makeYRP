# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tokens::Create, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:page) { create(:page) }
  let(:sheet) { create(:sheet) }

  describe 'create new token' do
    let(:input) do
      {
        page_id: page.id,
        sheet_id: sheet.id,
        position_x: 1,
        position_y: 0
      }
    end

    it 'save new token' do
      expect(interactor).to be_success
      token = interactor.success
      expect(token.page_id).to eq page.id
      expect(token.sheet_id).to eq sheet.id
      expect(token.position_x).to eq 1.0
      expect(token.position_y).to eq 0.0
    end
  end
end
