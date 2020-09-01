# frozen_string_literal: true

class Games::UsersController < Games::ApplicationController
  def index
    users = User.where(id: ids)
    render json: ShortUserSerializer.new(users, { params: { game: game } })
  end

  private

  def ids
    REDIS.lrange("game_#{game.id}", 0, -1)
  end
end
