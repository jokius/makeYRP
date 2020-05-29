# frozen_string_literal: true

class Tokens::Create
  include Dry::Monads[:result, :do]

  TOKEN_CREATE_SCHEMA = Dry::Schema.Params do
    required(:page_id).filled(:integer)
    required(:sheet_id).filled(:integer)
    required(:position_x).filled(:float)
    required(:position_y).filled(:float)
  end

  def call(input)
    params = yield validate(input)
    create(params)
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

  def create(input)
    token = Token.new(input)
    if token.save
      Success(token)
    else
      Failure(token.errors.to_h)
    end
  end
end
