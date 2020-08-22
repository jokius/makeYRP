# frozen_string_literal: true

# == Schema Information
#
# Table name: users_in_games
#
#  id         :bigint           not null, primary key
#  sheet      :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_users_in_games_on_game_id              (game_id)
#  index_users_in_games_on_game_id_and_user_id  (game_id,user_id)
#  index_users_in_games_on_user_id              (user_id)
#

class UsersInGame < ApplicationRecord
  belongs_to :game
  belongs_to :user
end
