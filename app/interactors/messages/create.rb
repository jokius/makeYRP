# frozen_string_literal: true

class Messages::Create
  include Dry::Transaction
  MASSAGES_CREATE_SCHEMA = Dry::Schema.Params do
    required(:game_id).filled(:integer)
    required(:user_id).filled(:integer)
    optional(:whisper_to_id).filled(:integer)
    required(:body).filled(:hash)
  end

  step :validate
  map :parse_body
  step :create

  def validate(input)
    result = MASSAGES_CREATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def parse_body(input)
    body = input[:body]
    dices = body['dices']
    body['dices'] = RollDices.new.call(dices, input[:game_id]) if dices
    input
  end

  def create(input)
    message = Message.new(input)
    if message.save
      Success(message)
    else
      Failure(message: message.errors.to_h, status: 422)
    end
  end
end
