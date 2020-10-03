class ChangeReadAllToToken < ActiveRecord::Migration[6.0]
  def change
    change_column :tokens, :read_all, :boolean, default: true
  end
end
