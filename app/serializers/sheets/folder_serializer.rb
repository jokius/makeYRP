# frozen_string_literal: true

class Sheets::FolderSerializer < BaseSerializer
  set_type :game_sheets_folder
  attributes :name, :depth, :path
  attribute :sheets do |folder|
    folder.sheets.map { |sheet| SheetSerializer.new(sheet) }
  end

  attribute :children do |folder|
    folder.children.map { |item| Sheets::FolderSerializer.new(item) }
  end
end
