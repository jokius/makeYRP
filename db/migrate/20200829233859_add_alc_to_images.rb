class AddAlcToImages < ActiveRecord::Migration[6.0]
  def change
    add_column :images, :owner_id, :bigint, null: true
    add_column :images, :read_all, :boolean, default: true, null: false
    add_column :images, :write_all, :boolean, default: false, null: false
  end
end
