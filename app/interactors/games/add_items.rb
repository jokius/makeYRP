# frozen_string_literal: true

class Games::AddItems
  include Dry::Monads[:result, :do]

  def call(input)
    game = yield fetch_game(input)
    add_items(game)
    Success(game)
  end

  private

  def fetch_game(input)
    game = Game.find_by(id: input)
    if game
      Success(game)
    else
      Failure(message: 'game not found', status: :not_fount)
    end
  end

  def add_items(game)
    items(game).each do |raw|
      game.items.find_or_create_by!(name: raw['name'], item_type: raw['type'], by_system: true) do |item|
        item.params = raw
      end
    end
  end

  def items(game)
    game.system.template['template']['items'] || []
  end
end
