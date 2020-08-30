class AddOwnerToGraphic < ActiveRecord::Migration[6.0]
  def change
    add_column :graphics, :owner_id, :bigint, null: true
  end
end
