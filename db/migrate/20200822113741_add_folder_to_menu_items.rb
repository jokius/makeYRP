class AddFolderToMenuItems < ActiveRecord::Migration[6.0]
  def change
    add_column :menus_items, :folder_id, :bigint
  end
end
