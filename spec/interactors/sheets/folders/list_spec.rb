# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sheets::Folders::List, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:user) { create(:user) }
  let(:game) { create(:game) }
  let(:input) do
    { user_id: user.id, game_id: game.id }
  end

  let(:root) { game.folders.root }
  let!(:child_folder) { create(:games_sheet_folder, parent: root, owner: root.owner, game: game) }
  let!(:root_sheet) { create(:sheet, game: game, folder: root, owner: root.owner) }
  let!(:child_sheet) { create(:sheet, game: game, folder: child_folder, owner: root.owner) }

  it 'when no owner and no access' do
    expect(interactor).to be_success
    result = interactor.success
    expect(result.name).to eq root.name
    expect(result.sheets.size).to eq 0
    expect(result.children.size).to eq 1
  end

  it 'when not owner and have access' do
    root_sheet.update(read_all: true)
    child_sheet.update(read_all: true)

    expect(interactor).to be_success
    result = interactor.success
    expect(result.name).to eq root.name
    expect(result.sheets.size).to eq 1
    expect(result.children.size).to eq 1
  end

  it 'when owner' do
    root.update(owner: user)
    child_folder.update(owner: user)
    game.update!(master: user)

    expect(interactor).to be_success
    result = interactor.success
    expect(result.name).to eq root.name
    expect(result.sheets.size).to eq 1
    expect(result.children.size).to eq 1
  end
end
