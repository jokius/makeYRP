class RemoveNameToMenus < ActiveRecord::Migration[6.0]
  def change
    remove_column :menus, :name, :string
  end
end
