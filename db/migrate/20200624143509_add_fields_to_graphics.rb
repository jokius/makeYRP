class AddFieldsToGraphics < ActiveRecord::Migration[6.0]
  def change
    add_column :graphics, :kind, :string
    add_column :graphics, :read_all, :boolean, default: true, null: false
    add_column :graphics, :write_all, :boolean, default: false, null: false
  end
end
