# frozen_string_literal: true

class Sheets::Update
  include Dry::Monads[:result, :do]

  SHEETS_UPDATE_SCHEMA = Dry::Schema.Params do
    required(:id).filled(:integer)
    required(:name).filled(:string)
    required(:params).filled(:hash)
  end

  def call(input)
    params = yield validate(input)
    hash = yield fetch_sheet(params)
    update(hash)
  end

  private

  def validate(input)
    result = SHEETS_UPDATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def fetch_sheet(input)
    sheet = Sheet.find_by(id: input.delete(:id))
    if sheet
      Success(sheet: sheet, input: input)
    else
      Failure(message: 'sheet not found', status: :not_fount)
    end
  end

  def update(sheet:, input:)
    if sheet.update(input)
      Success(sheet)
    else
      Failure(message: sheet.errors.to_h, status: 422)
    end
  end
end
