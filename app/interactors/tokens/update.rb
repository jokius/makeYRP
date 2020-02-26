# frozen_string_literal: true

class Tokens::Update
  include Dry::Monads[:result, :do]

  TOKEN_UPDATE_SCHEMA = Dry::Schema.Params do
    required(:id).filled(:integer)
    required(:position_x).filled(:float)
    required(:position_y).filled(:float)
  end

  def call(input)
    params = yield validate(input)
    hash = yield fetch_token(params)
    update(hash)
  end

  private

  def validate(input)
    result = TOKEN_UPDATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def fetch_token(input)
    token = Token.find_by(id: input.delete(:id))
    if token
      Success(token: token, input: input)
    else
      Failure(message: 'token not found', status: :not_fount)
    end
  end

  def update(token:, input:)
    token.assign_attributes(input)
    if token.save
      Success(token)
    else
      Failure(message: token.errors.to_h, status: 422)
    end
  end
end
