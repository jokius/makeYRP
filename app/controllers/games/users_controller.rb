# frozen_string_literal: true

class Games::UsersController < Games::ApplicationController
  def index
    render json: User.where(id: ids), each_serializer: ShortUserSerializer, game: game
  end

  private

  def ids
    REDIS.lrange("game_#{game.id}", 0, -1)
  end
end
