# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::AddItems, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:game) { create(:game, system: create(:system, :with_items)) }

  let(:input) { game.id }

  it 'add system menus' do
    expect(interactor).to be_success
    expect(game.items.size).to eq 1
  end
end
