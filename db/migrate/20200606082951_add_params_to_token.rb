class AddParamsToToken < ActiveRecord::Migration[6.0]
  def change
    remove_column :tokens, :position_x, :float
    remove_column :tokens, :position_y, :float
    add_column :tokens, :params, :jsonb, default: {}, null: false
  end
end
