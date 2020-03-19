# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe '#master?' do
    it 'master' do
      game = create(:game, master: user)
      expect(user.master?(game)).to be true
    end

    it 'player' do
      game = create(:game)
      game.users << user
      expect(user.master?(game)).to be false
    end

    it 'not have game' do
      game = create(:game)
      expect(user.master?(game)).to be false
    end
  end
end
