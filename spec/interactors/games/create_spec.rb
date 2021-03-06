# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::Create, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:user) { create(:user) }
  let(:system) { create(:system) }

  describe 'create new game' do
    let(:input) do
      {
        name: 'new game',
        system_id: system.id,
        master_id: user.id
      }
    end

    it 'save new game' do
      expect(interactor).to be_success
      game = interactor.success
      expect(game.name).to eq input[:name]
      expect(game.system_id).to eq system.id
      expect(game.master_id).to eq user.id
    end
  end

  describe 'failure create game' do
    let(:input) do
      {
        name: 'new game',
        system_id: -1,
        master_id: user.id
      }
    end

    it { expect(interactor).to be_failure }
  end
end
