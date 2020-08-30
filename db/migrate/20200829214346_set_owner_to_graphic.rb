class SetOwnerToGraphic < ActiveRecord::Migration[6.0]
  def up
    Graphic.find_each do |graphic|
      graphic.update(owner_id: graphic.page.game.master_id)
    end

    change_column_null :graphics, :owner_id, false
  end

  def down
    change_column_null :graphics, :owner_id, true
  end
end
