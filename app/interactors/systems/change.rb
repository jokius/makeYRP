# frozen_string_literal: true

class Systems::Change
  include Dry::Transaction

  step :parse
  step :save_system
  tee :update_games

  def parse(input)
    Systems::ParseTemplate.new.call(input)
  end

  def save_system(input)
    template = input[:template]
    version = template[:version]
    save(system(input, template, version))
  end

  def update_games(system)
    system.games.find_each do |game|
      Games::AddMenus.new.call(game.id)
    end
  end

  private

  def system(input, template, version)
    record = system_by_identifier(template[:identifier])
    record.assign_attributes(input.merge(version: version)) unless record.version == version.to_s
    record
  end

  def menu(raw:, system:)
    record = menu_by_identifier(system: system, identifier: raw[:type])
    record.assign_attributes(name: raw[name], params: raw)
    record
  end

  def system_by_identifier(identifier)
    System.find_or_initialize_by(key: identifier)
  end

  def menu_by_identifier(system:, identifier:)
    system.menus.find_or_initialize_by(identifier: identifier)
  end

  def save(system)
    if system.save
      Success(system)
    else
      Failure(message: system.errors.to_h, status: 422)
    end
  end

  def save_menu(menu)
    if menu.save
      Success(menu)
    else
      Failure(message: menu.errors.to_h, status: 422)
    end
  end
end
