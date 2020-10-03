# frozen_string_literal: true

class Tokens::Create
  include Dry::Monads[:result, :do]

  TOKEN_CREATE_SCHEMA = Dry::Schema.Params do
    required(:page_id).filled(:integer)
    required(:sheet_id).filled(:integer)
    required(:layer).filled(:string)
    required(:params).filled(:hash)
  end

  def call(input)
    params = yield validate(input)
    sheet = yield fetch_sheet(input)
    create(sheet, params)
  end

  private

  def validate(input)
    result = TOKEN_CREATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(result.errors.to_h)
    end
  end

  def fetch_sheet(input)
    sheet = Sheet.find_by(id: input[:sheet_id])
    if sheet
      Success(sheet)
    else
      Failure(message: 'sheet not found')
    end
  end

  def create(sheet, input)
    token = Token.new(input)
    token.write_all = sheet.write_all
    if token.save
      create_access_levels(sheet, token)
      Success(token)
    else
      Failure(token.errors.to_h)
    end
  end

  def create_access_levels(sheet, token)
    sheet.access_levels.find_each do |al|
      token.access_levels.create(user_id: al.user_id, write: al.write, read: al)
    end
  end
end
