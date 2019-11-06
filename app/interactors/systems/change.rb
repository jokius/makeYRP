# frozen_string_literal: true

class Systems::Change
  include Dry::Transaction

  step :parse
  step :change

  def parse(input)
    Systems::ParseTemplate.new.call(input)
  end

  def change(input)
    template = input[:template]
    version = template[:version]
    save(system(input, template, version))
  end

  private

  def system(input, template, version)
    record = system_by_key(template[:identifier])
    record.assign_attributes(input.merge(version: version)) unless record.version == version.to_s
    record
  end

  def system_by_key(key)
    System.find_or_initialize_by(key: key)
  end

  def save(system)
    if system.save
      Success(system)
    else
      Failure(message: system.errors.to_h, status: 422)
    end
  end
end
