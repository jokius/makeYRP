class AddNotNullLayerToGraphic < ActiveRecord::Migration[6.0]
  def up
    Graphic.update_all(layer: 'players')
    change_column_null :graphics, :layer, false
  end

  def down
    change_column_null :graphics, :layer, true
  end
end
