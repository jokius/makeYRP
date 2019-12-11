# frozen_string_literal: true

class Sheets::Update
  include Dry::Transaction
  SHEETS_UPDATE_SCHEMA = Dry::Schema.Params do
    required(:id).filled(:integer)
    required(:name).filled(:string)
    required(:params).filled(:hash)
  end

  step :validate
  step :update

  def validate(input)
    result = SHEETS_UPDATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def update(input)
    sheet = Sheet.find(input.delete(:id))
    if sheet.update(input)
      Success(sheet)
    else
      Failure(message: sheet.errors.to_h, status: 422)
    end
  end
end
