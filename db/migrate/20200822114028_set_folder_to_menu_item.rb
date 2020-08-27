class SetFolderToMenuItem < ActiveRecord::Migration[6.0]
  def up
    Menus::Item.find_each do |item|
      folder = item.menu.create_root_folder
      owner = item.owner
      item.update!(folder_id: folder.id, owner_id: owner.id)
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
