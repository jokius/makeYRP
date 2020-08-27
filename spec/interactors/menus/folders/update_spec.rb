# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Menus::Folders::Update, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:root) { create(:menus_item_folder) }
  let(:parent) { create(:menus_item_folder, parent: root) }
  let(:folder) { create(:menus_item_folder, parent: parent) }
  let(:input) do
    {
      id: folder.id,
      name: 'test'
    }
  end

  it 'update folder' do
    expect(interactor).to be_success
    result = interactor.success
    expect(result.id).not_to be_nil
    expect(result.name).to eq input[:name]
    expect(result.path).to match([parent.id, result.id])
    expect(result.items.size).to eq 0
    expect(result.children.size).to eq 0
  end
end
