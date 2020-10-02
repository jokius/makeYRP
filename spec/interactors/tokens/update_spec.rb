# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tokens::Update, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:token) { create(:token, params: { x: 0, y: 0 }) }
  let(:params) { { 'x' => 1.0, 'y' => 1.0 } }
  let(:input) do
    {
      id: token.id,
      params: params,
      layer: 'test'
    }
  end

  it 'update page' do
    expect(interactor).to be_success
    token = interactor.success
    expect(token.params).to match(params)
    expect(token.layer).to eq 'test'
  end
end
