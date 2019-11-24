# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pages::Update, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:page) { create(:page) }
  let(:new_name) { 'new page name' }
  let(:page_params) { { test_key: 'test' } }
  let(:input) do
    {
      id: page.id,
      name: new_name,
      page_params: page_params
    }
  end

  it 'update page' do
    expect(interactor).to be_success
    page = interactor.success
    expect(page.name).to eq input[:name]
    expect(page.params['test_key']).to eq page_params[:test_key]
  end
end
