# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Messages::Create, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:game) { create(:game) }
  let(:user) { create(:user) }
  let(:listener) { create(:user) }

  describe 'create new public message' do
    let(:input) do
      {
        game_id: game.id,
        user_id: user.id,
        body: {
          'text' => 'test message'
        }
      }
    end

    it 'save new message' do
      expect(interactor).to be_success

      message = interactor.success
      expect(message.game_id).to eq game.id
      expect(message.user_id).to eq user.id
      expect(message.whisper_to_id).to be_nil
      expect(message.body).to match input[:body]
    end
  end

  describe 'create new private message' do
    let(:input) do
      {
        game_id: game.id,
        user_id: user.id,
        whisper_to_id: listener.id,
        body: {
          'text' => 'test message'
        }
      }
    end

    it 'save new message' do
      expect(interactor).to be_success

      message = interactor.success
      expect(message.game_id).to eq game.id
      expect(message.user_id).to eq user.id
      expect(message.whisper_to_id).to eq listener.id
      expect(message.body).to match input[:body]
    end
  end
end
