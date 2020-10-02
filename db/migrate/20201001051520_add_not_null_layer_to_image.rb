class AddNotNullLayerToImage < ActiveRecord::Migration[6.0]
  def up
    Image.update_all(layer: 'players')
    change_column_null :images, :layer, false
  end

  def down
    change_column_null :images, :layer, true
  end
end
