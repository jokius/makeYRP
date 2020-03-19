# frozen_string_literal: true

class Games::Join
  include Dry::Monads[:result, :do]

  GAMES_JOIN_SCHEMA = Dry::Schema.Params do
    required(:game_id).filled(:integer)
    required(:user_id).filled(:integer)
  end

  def call(input)
    params = yield validate(input)
    game = game(params[:game_id])
    join(game: game, user_id: params[:user_id])

    Success(game)
  end

  private

  def validate(input)
    result = GAMES_JOIN_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def join(game:, user_id:)
    return if game.master_id == user_id || game.users.exists?(user_id)

    game.users << User.find(user_id)
  end

  def game(game_id)
    Game.find(game_id)
  end
end
