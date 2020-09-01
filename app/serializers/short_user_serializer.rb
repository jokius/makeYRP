# frozen_string_literal: true

class ShortUserSerializer < BaseSerializer
  attributes :nickname, :admin
  attribute :avatar, &:avatars

  attribute :sheet do |user, params|
    game = params[:game]
    if game
      user.users_in_games.find_by(game: game)&.sheet || {}
    else
      {}
    end
  end
end
