# frozen_string_literal: true

class Sheets::Create
  include Dry::Transaction
  SHEETS_CREATE_SCHEMA = Dry::Schema.Params do
    required(:owner_id).filled(:integer)
    required(:game_id).filled(:integer)
    required(:type).filled(:string)
    optional(:name).filled(:string)
  end

  step :validate
  step :create

  def validate(input)
    result = SHEETS_CREATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def create(input)
    sheet = Sheet.new(attrs_by(input))
    if sheet.save
      Success(sheet)
    else
      Failure(message: sheet.errors.to_h, status: 422)
    end
  end

  private

  def attrs_by(input)
    template = Game.find(input[:game_id]).system.template
    input[:params] = template.dig('actors', input.delete(:type)) || {}
    input[:name] = FFaker::Name.name if input[:name].blank?
    input
  end
end
