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

FactoryBot.define do
  factory :message do
    game
    user
    body do
      { text: FFaker::Tweet.tweet }
    end
  end
end
