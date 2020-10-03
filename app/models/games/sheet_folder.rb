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

require 'ostruct'

class Games::SheetFolder < ApplicationRecord
  acts_as_nested_set

  belongs_to :game
  belongs_to :owner, class_name: 'User'
  has_many :sheets, class_name: 'Sheet', foreign_key: :folder_id, dependent: :destroy

  def folder_struct(sheets:, children:, path_loaded: false)
    path = []
    path = load_path(self, path) if path_loaded

    OpenStruct.new(id: id,
                   name: name,
                   depth: depth,
                   sheets: sheets,
                   children: children,
                   path: path.reverse)
  end

  private

  def load_path(folder, path)
    return path if folder.root?

    path << folder.id
    load_path(folder.parent, path)
  end
end
