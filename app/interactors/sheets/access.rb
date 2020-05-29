# frozen_string_literal: true

class Sheets::Access
  include Dry::Monads[:result, :do]

  SHEETS_UPDATE_SCHEMA = Dry::Schema.Params do
    required(:id).filled(:integer)
    required(:read_all).filled(:bool)
    required(:write_all).filled(:bool)
    required(:levels).each do
      hash do
        required(:user_id).filled(:integer)
        required(:read).filled(:bool)
        required(:write).filled(:bool)
      end
    end
  end

  def call(input)
    ActiveRecord::Base.transaction do
      params = yield validate(input)
      sheet = yield fetch_sheet(params)
      save_access(sheet, params)
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

  def save_access(sheet, params)
    yield save_access_levels(sheet, params.delete(:levels))
    sheet.assign_attributes(params)
    if sheet.save
      Success(sheet)
    else
      Failure(message: sheet.errors.to_h)
    end
  end

  def save_access_levels(sheet, levels)
    levels.each do |item|
      item[:user_id]
      acl = sheet.access_levels.find_or_initialize_by(user_id: item[:user_id])
      acl.read = item[:read]
      acl.write = item[:write]
      return Failure(message: acl.errors.to_h) unless acl.save
    end

    Success()
  end
end
