# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Menus::ItemFolderPolicy, type: :policy do
  let(:user) { create :user }
  let(:game) { create :game }
  let(:record) { create(:menus_item_folder, menu: create(:menu, game: game)) }
  let(:context) { { user: user } }

  describe_rule :write? do
    failed 'when no access'

    succeed 'when master' do
      let(:game) { create(:game, master: user) }
    end
  end

  describe_rule :remove? do
    failed 'when no access'

    succeed 'when master' do
      let(:game) { create(:game, master: user) }
    end
  end
end
