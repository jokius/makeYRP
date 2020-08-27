class CreateMenusItemFolders < ActiveRecord::Migration[6.0]
  def change
    create_table :menus_item_folders do |t|
      t.belongs_to :menu, index: true
      t.belongs_to :owner
      t.string :name
      t.integer :parent_id, null: true, index: true
      t.integer :lft, null: false, index: true
      t.integer :rgt, null: false, index: true
      t.integer :depth, null: false, default: 0
      t.integer :children_count, null: false, default: 0

      t.timestamps
    end
  end
end
