# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Menus::Folders::List, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:user) { create(:user) }
  let(:menu) { create(:menu) }
  let(:input) do
    { user_id: user.id, menu_id: menu.id }
  end

  let(:root) { menu.folders.root }
  let!(:child_folder) { create(:menus_item_folder, parent: root, owner: root.owner, menu: menu) }
  let!(:root_item) { create(:menus_item, menu: menu, folder: root, owner: root.owner) }
  let!(:child_item) { create(:menus_item, menu: menu, folder: child_folder, owner: root.owner) }

  it 'when no owner and no access' do
    expect(interactor).to be_success
    result = interactor.success
    expect(result.name).to eq root.name
    expect(result.items.size).to eq 0
    expect(result.children.size).to eq 1
  end

  it 'when not owner and have access' do
    root_item.update(read_all: true)
    child_item.update(read_all: true)

    expect(interactor).to be_success
    result = interactor.success
    expect(result.name).to eq root.name
    expect(result.items.size).to eq 1
    expect(result.children.size).to eq 1
  end

  it 'when owner' do
    root.update(owner: user)
    child_folder.update(owner: user)
    menu.game.update!(master: user)

    expect(interactor).to be_success
    result = interactor.success
    expect(result.name).to eq root.name
    expect(result.items.size).to eq 1
    expect(result.children.size).to eq 1
  end
end
