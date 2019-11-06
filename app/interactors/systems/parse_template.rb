# frozen_string_literal: true

class Systems::ParseTemplate
  include Dry::Transaction
  SYSTEM_SCHEMA = Dry::Schema.Params do
    required(:name).filled(:string)
    required(:text).maybe(:string)
    required(:file).maybe(:any)
  end

  step :validate
  map :parse

  def validate(input)
    result = SYSTEM_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def parse(input)
    file = input[:file]
    template = file.present? ? file.read : input[:text]
    { name: input[:name], template: JSON.parse(template, symbolize_names: true) }
  end
end
