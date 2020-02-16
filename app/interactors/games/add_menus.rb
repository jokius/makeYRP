# frozen_string_literal: true

class Games::AddMenus
  include Dry::Monads[:result, :do]

  def call(input)
    game = yield fetch_game(input)
    yield add_notes(game)
    yield add_system_menus(game)
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

  def add_notes(game)
    menu = game.menus.find_or_initialize_by(identifier: :notes)
    menu.params = { icon: 'mdi-notebook', name: 'Заметки', type: :notes }
    if menu.save
      Success(game)
    else
      Failure(message: menu.errors.to_h, status: 422)
    end
  end

  def add_system_menus(game)
    (game.system.template.dig('template', 'menus') || []).each do |template|
      menu = game.menus.find_or_initialize_by(identifier: template['type'])
      menu.params = template
      return Failure(message: menu.errors.to_h, status: 422) unless menu.save
    end

    Success(game)
  end
end
