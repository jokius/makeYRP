# frozen_string_literal: true

class Pages::Create
  include Dry::Transaction
  PAGES_CREATE_SCHEMA = Dry::Schema.Params do
    required(:game_id).filled(:integer)
    required(:name).filled(:string)
  end

  step :validate
  step :create

  def validate(input)
    result = PAGES_CREATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def create(input)
    page = Page.new(input)
    if page.save
      Success(page)
    else
      Failure(message: page.errors.to_h, status: 422)
    end
  end
end
