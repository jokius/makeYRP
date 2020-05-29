# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tokens::Update, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:token) { create(:token) }
  let(:input) do
    {
      id: token.id,
      position_x: 1,
      position_y: 1
    }
  end

  it 'update page' do
    expect(interactor).to be_success
    token = interactor.success
    expect(token.position_x).to eq 1.0
    expect(token.position_y).to eq 1.0
  end
end
