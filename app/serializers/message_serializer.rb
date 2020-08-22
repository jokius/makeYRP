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

class MessageSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at

  belongs_to :user, serializer: ShortUserSerializer
end
