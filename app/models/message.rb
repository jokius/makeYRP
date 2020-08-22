# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id            :bigint           not null, primary key
#  body          :jsonb
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  game_id       :bigint           not null
#  user_id       :bigint           not null
#  whisper_to_id :bigint
#
# Indexes
#
#  index_messages_on_game_id        (game_id)
#  index_messages_on_user_id        (user_id)
#  index_messages_on_whisper_to_id  (whisper_to_id)
#

class Message < ApplicationRecord
  belongs_to :game
  belongs_to :user
  belongs_to :whisper_to, class_name: 'User', optional: true
end
