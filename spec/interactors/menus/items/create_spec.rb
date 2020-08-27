# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Menus::Items::Create, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:folder) { create(:menus_item_folder) }
  let(:input) do
    {
      owner_id: create(:user).id,
      folder_id: folder.id,
      params: { name: 'test' }
    }
  end

  it 'create new menu item' do
    expect(interactor).to be_success
    expect(folder.items.size).to eq 1
  end
end
