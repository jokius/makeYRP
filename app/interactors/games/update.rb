# frozen_string_literal: true

class Games::Update
  include Dry::Monads[:result, :do]

  GAMES_UPDATE_SCHEMA = Dry::Schema.Params do
    required(:game_id).filled(:integer)
    required(:name).filled(:string)
    optional(:custom_template).maybe(:any)
  end

  def call(input)
    params = yield validate(input)
    hash = yield fetch_game(params)
    update(hash)
  end

  private

  def validate(input)
    result = GAMES_UPDATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def fetch_game(input)
    game = Game.find_by(id: input.delete(:game_id))
    if game
      Success(game: game, input: input)
    else
      Failure(message: 'game not found')
    end
  end

  def update(game:, input:)
    game.name = input[:name]
    game.custom_system_attributes = { template: input[:custom_template] || {} }

    if game.save
      Success(game)
    else
      Failure(message: game.errors.to_h)
    end
  end
end
