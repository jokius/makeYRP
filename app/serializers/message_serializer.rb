# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id            :bigint           not null, primary key
#  game_id       :bigint           not null
#  user_id       :bigint           not null
#  whisper_to_id :bigint
#  body          :jsonb
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class MessageSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at

  belongs_to :user, serializer: ShortUserSerializer
end
