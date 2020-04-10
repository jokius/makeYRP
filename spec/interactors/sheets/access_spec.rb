# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sheets::Access, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:sheet) { create(:sheet) }

  describe 'change access sheet' do
    context 'when for single user' do
      let(:user) { create(:user) }

      let(:input) do
        { id: sheet.id, user_id: user.id, read: true, write: false }
      end

      it 'save new sheet' do
        expect(interactor).to be_success
        sheet = interactor.success
        access_level = sheet.access_levels.find_by(user: user)
        expect(access_level).to be_read
        expect(access_level).not_to be_write
      end
    end

    context 'when for all users' do
      let(:input) do
        { id: sheet.id, user_id: nil, read: true, write: false }
      end

      it 'save new sheet' do
        expect(interactor).to be_success
        sheet = interactor.success
        expect(sheet).to be_read_all
        expect(sheet).not_to be_write_all
      end
    end
  end
end
