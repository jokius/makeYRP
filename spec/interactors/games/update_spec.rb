# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::Update, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:game) { create(:game) }

  describe 'update game' do
    context 'with name' do
      let(:input) do
        { game_id: game.id, name: 'super name', custom_template: { 'item' => 'new item'} }
      end

      it { expect(interactor).to be_success }

      it 'save new game' do
        game = interactor.success
        expect(game.name).to eq input[:name]
        expect(game.custom_system.template).to match input[:custom_template]
      end
    end
  end
end
