# frozen_string_literal: true

class Images::Create
  include Dry::Monads[:result, :do]

  IMAGE_CREATE_SCHEMA = Dry::Schema.Params do
    required(:owner_id).filled(:integer)
    required(:page_id).filled(:integer)
    required(:layer).filled(:string)
    required(:params).filled(:hash)
  end

  def call(input)
    params = yield validate(input)
    create(params)
  end

  private

  def validate(input)
    result = IMAGE_CREATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(result.errors.to_h)
    end
  end

  def create(input)
    image = Image.new(input)
    if image.save
      Success(image)
    else
      Failure(image.errors.to_h)
    end
  end
end
