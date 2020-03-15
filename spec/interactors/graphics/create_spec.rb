# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Graphics::Create, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:page) { create(:page) }

  describe 'create new graphic' do
    let(:input) do
      {
        page_id: page.id,
        layer: 'test',
        params: { 'text' => 'params' }
      }
    end

    it 'save new graphic' do
      expect(interactor).to be_success
      graphic = interactor.success
      expect(graphic.page_id).to eq input[:page_id]
      expect(graphic.layer).to eq input[:layer]
      expect(graphic.params).to eq input[:params]
    end
  end
end
