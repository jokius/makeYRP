# frozen_string_literal: true

# == Schema Information
#
# Table name: menus_item_folders
#
#  id             :bigint           not null, primary key
#  children_count :integer          default(0), not null
#  depth          :integer          default(0), not null
#  lft            :integer          not null
#  name           :string
#  rgt            :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  menu_id        :bigint
#  owner_id       :bigint
#  parent_id      :integer
#
# Indexes
#
#  index_menus_item_folders_on_lft        (lft)
#  index_menus_item_folders_on_menu_id    (menu_id)
#  index_menus_item_folders_on_owner_id   (owner_id)
#  index_menus_item_folders_on_parent_id  (parent_id)
#  index_menus_item_folders_on_rgt        (rgt)
#

require 'ostruct'

class Menus::ItemFolder < ApplicationRecord
  acts_as_nested_set

  belongs_to :menu
  belongs_to :owner, class_name: 'User'
  has_many :items, class_name: 'Menus::Item', foreign_key: :folder_id, dependent: :destroy
  delegate :game, to: :menu

  def folder_struct(items:, children:, path_loaded: false)
    path = []
    path = load_path(self, path) if path_loaded

    OpenStruct.new(id: id,
                   name: name,
                   menu_id: menu_id,
                   depth: depth,
                   items: items,
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
