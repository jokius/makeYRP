# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::Update, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:game) { create(:game) }

  describe 'update game' do
    context 'with name' do
      let(:input) do
        { id: game.id, name: 'super name' }
      end

      it { expect(interactor).to be_success }

      it 'save new game' do
        game = interactor.success
        expect(game.name).to eq input[:name]
      end
    end
  end
end
