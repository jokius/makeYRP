class AddAclToToken < ActiveRecord::Migration[6.0]
  def change
    add_column :tokens, :read_all, :boolean, default: false, null: false
    add_column :tokens, :write_all, :boolean, default: false, null: false
  end
end
