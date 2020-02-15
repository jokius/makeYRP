# frozen_string_literal: true

class Games::Create
  include Dry::Monads[:result, :do]

  GAMES_CREATE_SCHEMA = Dry::Schema.Params do
    required(:name).filled(:string)
    required(:system_id).filled(:integer)
    required(:master_id).filled(:integer)
  end

  def call(input)
    result = nil
    begin
      ActiveRecord::Base.transaction do
        result = transaction(input)
        raise ActiveRecord::Rollback if result.failure?
      end

      result
    rescue ActiveRecord::Rollback
      result
    end
  end

  private

  def transaction(input)
    params = yield validate(input)
    game = yield create(params)
    add_menu(game)
  end

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
      Failure(game.errors.to_h)
    end
  end

  def add_menu(game)
    Games::AddMenus.new.call(game.id)
  end
end
