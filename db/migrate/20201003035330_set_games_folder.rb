class SetGamesFolder < ActiveRecord::Migration[6.0]
  def up
    Game.all.find_each do |game|
      folder = game.create_root_folder
      game.sheets.update_all(folder_id: folder.id)
    end
  end

  def down; end
end
