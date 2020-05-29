class AddIdentifierToMenu < ActiveRecord::Migration[6.0]
  def change
    add_column :menus, :identifier, :string, null: false
  end
end
