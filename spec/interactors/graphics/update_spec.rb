# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Graphics::Update, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:graphic) { create(:graphic) }
  let(:new_text) { 'new text' }
  let(:input) do
    {
      id: graphic.id,
      params: { 'text' => new_text }
    }
  end

  it 'update page' do
    expect(interactor).to be_success
    graphic = interactor.success
    expect(graphic.params['text']).to eq new_text
  end
end
