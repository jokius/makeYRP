# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Menus::Folders::Create, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:user) { create(:user) }
  let(:root) { create(:menus_item_folder) }
  let(:parent) { create(:menus_item_folder, parent: root) }
  let(:input) do
    { owner_id: user.id, parent_id: parent.id, name: 'test folder name' }
  end

  it 'create new menu folder' do
    expect(interactor).to be_success
    result = interactor.success
    expect(result.id).not_to be_nil
    expect(result.name).to eq input[:name]
    expect(result.path).to match([parent.id, result.id])
    expect(result.items.size).to eq 0
    expect(result.children.size).to eq 0
  end
end
