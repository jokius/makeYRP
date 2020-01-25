# frozen_string_literal: true

class Games::Create
  include Dry::Transaction

  GAMES_CREATE_SCHEMA = Dry::Schema.Params do
    required(:name).filled(:string)
    required(:system_id).filled(:integer)
    required(:master_id).filled(:integer)
  end

  step :validate
  step :create
  tee :add_menu

  def validate(input)
    result = GAMES_CREATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def create(input)
    game = Game.new(input)
    if game.save
      Success(game)
    else
      Failure(message: game.errors.to_h, status: 422)
    end
  end

  def add_menu(game)
    Games::AddMenus.new.call(game.id)
  end
end
