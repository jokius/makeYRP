# frozen_string_literal: true

class Systems::Change
  include Dry::Monads[:result, :do]

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
    media_file = input.delete(:media_file)
    hash = yield parse(input)
    system = yield save_system(hash)
    upload_media(system, media_file)
    update_games(system)
  end

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
      result = Games::AddMenus.new.call(game.id)
      return result if result.failure?
    end

    Success(system)
  end

  def upload_media(system, media_file)
    Systems::LoadMedias.new.call(id: system.id, media_file: media_file)
  end

  def system(input, template, version)
    record = system_by_identifier(template[:identifier])
    record.assign_attributes(input.merge(version: version)) unless record.version == version.to_s
    record
  end

  def system_by_identifier(identifier)
    System.find_or_initialize_by(key: identifier)
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
