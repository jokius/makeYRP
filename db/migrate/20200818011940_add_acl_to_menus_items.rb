class AddAclToMenusItems < ActiveRecord::Migration[6.0]
  def change
    add_column :menus_items, :owner_id, :bigint, null: true
    add_column :menus_items, :read_all, :boolean, default: false, null: false
    add_column :menus_items, :write_all, :boolean, default: false, null: false
  end
end
