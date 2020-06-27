# frozen_string_literal: true

# == Schema Information
#
# Table name: users_in_games
#
#  id         :bigint           not null, primary key
#  game_id    :bigint           not null
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sheet      :jsonb
#

class UsersInGame < ApplicationRecord
  belongs_to :game
  belongs_to :user
end
