# frozen_string_literal: true

class ShortUserSerializer < ActiveModel::Serializer
  attributes :id, :nickname, :admin
  attribute :avatars, key: :avatar

  attribute :sheet do
    game = instance_options[:game]
    if game
      object.users_in_games.find_by(game: game)&.sheet || {}
    else
      {}
    end
  end
end
