# frozen_string_literal: true

class Games::AddMenus
  include Dry::Transaction(container: TransactionContainer)

  around :transaction, with: 'transaction'
  map :fetch_game
  tee :add_notes
  tee :add_system_menus

  def fetch_game(input)
    Game.find(input)
  end

  def add_notes(game)
    menu = game.menus.find_or_initialize_by(identifier: :notes)
    menu.params = { icon: 'mdi-notebook', name: 'Заметки', type: :notes }
    menu.save
  end

  def add_system_menus(game)
    (game.system.template.dig('template', 'menus') || []).each do |template|
      menu = game.menus.find_or_initialize_by(identifier: template['type'])
      menu.params = template
      menu.save
    end
  end
end
