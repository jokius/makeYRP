# frozen_string_literal: true

class Menus::FolderSerializer < BaseSerializer
  set_type :menu_items_folder
  attributes :name, :menu_id, :depth, :path
  attribute :items do |folder|
    folder.items.map { |item| Menus::ItemSerializer.new(item) }
  end

  attribute :children do |folder|
    folder.children.map { |item| Menus::FolderSerializer.new(item) }
  end
end
