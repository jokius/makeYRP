# frozen_string_literal: true

# == Schema Information
#
# Table name: games_sheet_folders
#
#  id             :bigint           not null, primary key
#  children_count :integer          default(0), not null
#  depth          :integer          default(0), not null
#  lft            :integer          not null
#  name           :string
#  rgt            :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  game_id        :bigint
#  owner_id       :bigint
#  parent_id      :integer
#
# Indexes
#
#  index_games_sheet_folders_on_game_id    (game_id)
#  index_games_sheet_folders_on_lft        (lft)
#  index_games_sheet_folders_on_owner_id   (owner_id)
#  index_games_sheet_folders_on_parent_id  (parent_id)
#  index_games_sheet_folders_on_rgt        (rgt)
#
FactoryBot.define do
  factory :games_sheet_folder, class: 'Games::SheetFolder' do
    name { FFaker::Product.product_name }
    owner { create(:user) }
    game
  end
end
