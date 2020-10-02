class AddNotNullLayerToToken < ActiveRecord::Migration[6.0]
  def up
    Token.update_all(layer: 'players')
    change_column_null :tokens, :layer, false
  end

  def down
    change_column_null :tokens, :layer, true
  end
end
