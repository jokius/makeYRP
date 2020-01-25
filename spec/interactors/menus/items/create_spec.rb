# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Menus::Items::Create, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:game) { create(:game) }
  let(:menu) { create(:menu, game: game) }

  describe 'create new menu item' do
    let(:input) do
      {
        game_id: game.id,
        type: menu.identifier,
        params: { name: 'test' }
      }
    end

    it 'save new game' do
      expect(interactor).to be_success
      expect(menu.items.size).to eq 1
    end
  end
end
