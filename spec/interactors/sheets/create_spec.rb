# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sheets::Create, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:user) { create(:user) }
  let(:system) { create(:system, :test_actor) }
  let(:game) { create(:game, system: system) }

  describe 'create new sheet' do
    context 'with name' do
      let(:input) do
        {
          name: 'super name',
          game_id: game.id,
          owner_id: user.id,
          type: 'test_actor'
        }
      end

      it 'save new sheet' do
        sheet = interactor.success
        expect(sheet.name).to eq input[:name]
        expect(sheet.game_id).to eq game.id
        expect(sheet.owner_id).to eq user.id
        expect(sheet.params).to match system.template['actors']['test_actor']
      end
    end

    context 'without name' do
      let(:input) do
        {
          name: '',
          game_id: game.id,
          owner_id: user.id,
          type: 'test_actor'
        }
      end

      it 'save new sheet' do
        sheet = interactor.success
        expect(sheet.name).not_to be_blank
        expect(sheet.game_id).to eq game.id
        expect(sheet.owner_id).to eq user.id
        expect(sheet.params).to match system.template['actors']['test_actor']
      end
    end
  end
end