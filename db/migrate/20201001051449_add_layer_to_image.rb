class AddLayerToImage < ActiveRecord::Migration[6.0]
  def change
    add_column :images, :layer, :string
  end
end
