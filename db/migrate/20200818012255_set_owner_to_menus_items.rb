class SetOwnerToMenusItems < ActiveRecord::Migration[6.0]
  def up
    Menus::Item.find_each do |item|
      item.update(owner_id: item.menu.game.master_id)
    end

    change_column_null :menus_items, :owner_id, false
  end

  def down
    change_column_null :menus_items, :owner_id, true
  end
end
