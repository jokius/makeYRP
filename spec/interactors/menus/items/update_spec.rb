# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Menus::Items::Update, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:menu_item) { create(:menus_item) }
  let(:input) do
    {
      id: menu_item.id,
      params: { 'name' => 'test' }
    }
  end

  it 'update menu item' do
    expect(interactor).to be_success
    expect(menu_item.reload.params).to match(input[:params])
  end
end
