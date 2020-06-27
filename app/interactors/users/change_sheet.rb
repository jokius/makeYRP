# frozen_string_literal: true

class Users::ChangeSheet
  include Dry::Monads[:result, :do]

  USERS_CHANGE_SHEET_SCHEMA = Dry::Schema.Params do
    required(:game_id).filled(:integer)
    required(:user_id).filled(:integer)
    optional(:sheet).maybe(:any)
  end

  def call(input)
    params = yield validate(input)
    hash = yield fetch_user_in_game(params)
    update(hash)
  end

  private

  def validate(input)
    result = USERS_CHANGE_SHEET_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(result.errors.to_h)
    end
  end

  def fetch_user_in_game(input)
    user_in_game = UsersInGame.find_by(game_id: input[:game_id], user_id: input[:user_id])
    if user_in_game
      Success(user_in_game: user_in_game, input: input)
    else
      Failure('user in game not found')
    end
  end

  def update(user_in_game:, input:)
    user_in_game.sheet = input[:sheet] || {}
    if user_in_game.save
      Success(user_in_game.user)
    else
      Failure(user_in_game.errors.to_h)
    end
  end
end
