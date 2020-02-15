# frozen_string_literal: true

class Sheets::Create
  include Dry::Monads[:result, :do]

  SHEETS_CREATE_SCHEMA = Dry::Schema.Params do
    required(:owner_id).filled(:integer)
    required(:game_id).filled(:integer)
    required(:sheet_type).filled(:string)
    optional(:name).maybe(:string)
  end

  def call(input)
    create(yield validate(input))
  end

  private

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

  def attrs_by(input)
    template = Game.find(input[:game_id]).system.template
    input[:params] = template.dig('template', 'sheets', input[:sheet_type]) || {}
    input[:name] = FFaker::Name.name if input[:name].blank?
    input
  end
end
