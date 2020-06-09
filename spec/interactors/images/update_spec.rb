# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Images::Update, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:image) { create(:image, params: { x: 0, y: 0 }) }
  let(:params) { { 'x' => 1.0, 'y' => 1.0 } }
  let(:input) do
    {
      id: image.id,
      params: params
    }
  end

  it 'update page' do
    expect(interactor).to be_success
    image = interactor.success
    expect(image.params).to match(params)
  end
end
