# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::AddMenus, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:game) { create(:game, system: create(:system, :with_menu)) }

  let(:input) { game.id }

  it 'add system menus' do
    expect(interactor).to be_success
    expect(game.menus.size).to eq 2
  end
end
