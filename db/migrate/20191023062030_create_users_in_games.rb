class CreateUsersInGames < ActiveRecord::Migration[6.0]
  def change
    create_table :users_in_games do |t|
      t.belongs_to :game, null: false, index: true
      t.belongs_to :user, null: false, index: true

      t.timestamps
    end

    add_index :users_in_games, %i[game_id user_id]
  end
end
