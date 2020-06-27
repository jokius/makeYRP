class AddSheetToUsersInGames < ActiveRecord::Migration[6.0]
  def change
    add_column :users_in_games, :sheet, :jsonb, default: {}
  end
end
