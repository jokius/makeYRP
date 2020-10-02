class AddLayerToToken < ActiveRecord::Migration[6.0]
  def change
    add_column :tokens, :layer, :string
  end
end
