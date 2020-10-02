# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tokens::Create, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:page) { create(:page) }
  let(:sheet) { create(:sheet, :with_acl, read_all: false, write_all: false) }

  describe 'create new token' do
    let(:input) do
      {
        page_id: page.id,
        sheet_id: sheet.id,
        params: { x: 0, y: 0 },
        layer: 'players'
      }
    end

    it 'save new token' do
      expect(interactor).to be_success
      token = interactor.success
      access_level = token.access_levels.first
      sheet_access_level = sheet.access_levels.first

      expect(token.page_id).to eq page.id
      expect(token.sheet_id).to eq sheet.id
      expect(access_level.user).to eq sheet_access_level.user
      expect(access_level.write).to eq sheet_access_level.write
      expect(access_level.read).to eq sheet_access_level.read
    end
  end
end
