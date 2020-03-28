# frozen_string_literal: true

class Sheets::Access
  include Dry::Monads[:result, :do]

  SHEETS_UPDATE_SCHEMA = Dry::Schema.Params do
    required(:id).filled(:integer)
    required(:user_id).maybe(:integer)
    required(:read).filled(:bool)
    required(:write).filled(:bool)
  end

  def call(input)
    params = yield validate(input)
    sheet = yield fetch_sheet(params)
    if params[:user_id]
      user_access(sheet, params)
    else
      all_access(sheet, params)
    end
  end

  private

  def validate(input)
    result = SHEETS_UPDATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h)
    end
  end

  def fetch_sheet(input)
    sheet = Sheet.find_by(id: input.delete(:id))
    if sheet
      Success(sheet)
    else
      Failure(message: 'sheet not found')
    end
  end

  def user_access(sheet, params)
    acl = sheet.access_levels.find_or_initialize_by(user_id: params[:user_id])
    acl.read = params[:read]
    acl.write = params[:write]
    if acl.save
      Success(sheet)
    else
      Failure(message: acl.errors.to_h)
    end
  end

  def all_access(sheet, params)
    sheet.read_all = params[:read]
    sheet.write_all = params[:write]

    if sheet.save
      Success(sheet)
    else
      Failure(message: sheet.errors.to_h)
    end
  end
end
