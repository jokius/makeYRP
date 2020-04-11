# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sheets::Access, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:sheet) { create(:sheet) }
  let(:user) { create(:user) }

  describe 'change access sheet' do
    let(:input) do
      { id: sheet.id,
        read_all: true,
        write_all: false,
        levels: [{ user_id: user.id,
                   read: true,
                   write: false }]
      }
    end

    it 'save user access' do
      expect(interactor).to be_success
      sheet = interactor.success
      access_level = sheet.access_levels.find_by(user: user)
      expect(access_level).to be_read
      expect(access_level).not_to be_write
    end

    it 'save all access' do
      expect(interactor).to be_success
      sheet = interactor.success
      expect(sheet).to be_read_all
      expect(sheet).not_to be_write_all
    end
  end
end
