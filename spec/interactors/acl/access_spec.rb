# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Acl::Access, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:user) { create(:user) }

  describe 'change access sheet' do
    let(:sheet) { create(:sheet) }
    let(:input) do
      { type: 'sheet',
        id: sheet.id,
        read_all: true,
        write_all: false,
        levels: [{ user_id: user.id,
                   read: true,
                   write: false }] }
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

  describe 'change access menu_item' do
    let(:menu_item) { create(:menus_item) }
    let(:input) do
      { type: 'menu_item',
        id: menu_item.id,
        read_all: true,
        write_all: false,
        levels: [{ user_id: user.id,
                   read: true,
                   write: false }] }
    end

    it 'save user access' do
      expect(interactor).to be_success
      menu_item = interactor.success
      access_level = menu_item.access_levels.find_by(user: user)
      expect(access_level).to be_read
      expect(access_level).not_to be_write
    end

    it 'save all access' do
      expect(interactor).to be_success
      menu_item = interactor.success
      expect(menu_item).to be_read_all
      expect(menu_item).not_to be_write_all
    end
  end
end
