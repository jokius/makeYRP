# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::Join, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:user) { create(:user) }
  let(:game) { create(:game) }

  describe 'join to game' do
    let(:input) do
      {
        name: 'new game',
        game_id: game.id,
        user_id: user.id
      }
    end

    it 'new user' do
      expect(interactor).to be_success
      game = interactor.success
      expect(game.users.last).to eq user
    end

    context 'when old user' do
      before { game.users << user }

      it 'no change' do
        expect(interactor).to be_success
        game = interactor.success
        expect(game.users.last).to eq user
        expect(game.users.count).to eq 1
      end
    end

    context 'when master' do
      before { game.update(master: user) }

      it 'no change' do
        expect(interactor).to be_success
        game = interactor.success
        expect(game.users.count).to eq 0
      end
    end
  end
end
