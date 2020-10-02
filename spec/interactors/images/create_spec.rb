# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Images::Create, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:page) { create(:page) }

  describe 'create new image' do
    let(:input) do
      {
        owner_id: create(:user).id,
        page_id: page.id,
        params: { x: 0, y: 0 },
        layer: 'players'
      }
    end

    it 'save new token' do
      expect(interactor).to be_success
    end
  end
end
