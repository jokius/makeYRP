# frozen_string_literal: true

class Games::UsersController < Games::ApplicationController
  def index
    users = User.where(id: ids)
    render json: ShortUserSerializer.new(users, { params: { game: game } })
  end

  private

  def ids
    REDIS.keys("game_#{game.id}_user_*").map { |key| REDIS.get(key) }
  end
end
