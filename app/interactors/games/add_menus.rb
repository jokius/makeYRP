# frozen_string_literal: true

class Games::AddMenus
  include Dry::Transaction

  map :fetch_game
  tee :remove_old_menus
  tee :add_menus

  def fetch_game(input)
    Game.find(input)
  end

  def remove_old_menus(game)
    game.menus.destroy_all
  end

  def add_menus(game)
    (game.system.template.dig('template', 'menus') || []).each do |template|
      menu = game.menus.find_or_initialize_by(identifier: template['type'])
      menu.params = template
      menu.save
    end
  end
end
