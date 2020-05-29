# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pages::Create, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:game) { create(:game) }

  describe 'create new page' do
    let(:input) do
      {
        name: 'super name',
        game_id: game.id
      }
    end

    it 'save new page' do
      page = interactor.success
      expect(page.name).to eq input[:name]
      expect(page.game_id).to eq game.id
    end
  end
end
