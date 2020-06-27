# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::ChangeSheet, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:user) { create(:user) }
  let(:game) { create(:game) }
  let!(:users_in_game) { create(:users_in_game, game: game, user: user) }

  describe 'add sheet' do
    let(:input) do
      {
        game_id: game.id,
        user_id: user.id,
        sheet: sheet
      }
    end

    context 'when sheet with params' do
      let(:sheet) { { 'name' => 'test' } }

      it do
        expect(interactor).to be_success
        expect(users_in_game.reload.sheet).to match(sheet)
      end
    end

    context 'when sheet without params' do
      let(:sheet) { {} }

      before do
        users_in_game.update(sheet: { name: 'test' })
      end

      it do
        expect(interactor).to be_success
        expect(users_in_game.reload.sheet).to match(sheet)
      end
    end
  end
end
