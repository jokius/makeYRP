# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Menus::Items::Create, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:menu) { create(:menu) }

  describe 'create new menu item' do
    let(:input) do
      {
        owner_id: create(:user).id,
        menu_id: menu.id,
        params: { name: 'test' }
      }
    end

    it 'save new game' do
      expect(interactor).to be_success
      expect(menu.items.size).to eq 1
    end
  end
end
