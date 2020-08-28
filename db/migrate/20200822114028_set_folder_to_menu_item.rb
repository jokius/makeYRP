class SetFolderToMenuItem < ActiveRecord::Migration[6.0]
  def up
    Menu.find_each do |menu|
      next if menu.folders.any?
      next menu.destroy if menu.game.nil?
      next menu.game.destroy if menu.game.master.nil?

      folder = menu.create_root_folder
      owner = menu.owner
      Menus::Item.find_by(menu_id: menu.id).update_all(folder_id: folder.id, owner_id: owner.id)
    end

    change_column_null :menus_items, :folder_id, false
    add_index :menus_items, :folder_id
    add_index :menus_items, %i[menu_id folder_id]
  end

  def down
    change_column_null :menus_items, :folder_id, true
    remove_index :menus_items, :folder_id
    remove_index :menus_items, %i[menu_id folder_id]
  end
end
