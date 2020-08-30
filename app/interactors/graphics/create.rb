# frozen_string_literal: true

class Graphics::Create
  include Dry::Monads[:result, :do]

  GRAPHIC_CREATE_SCHEMA = Dry::Schema.Params do
    required(:owner_id).filled(:integer)
    required(:page_id).filled(:integer)
    required(:kind).filled(:string)
    required(:params).filled(:hash)
  end

  def call(input)
    params = yield validate(input)
    create(params)
  end

  private

  def validate(input)
    result = GRAPHIC_CREATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h)
    end
  end

  def create(input)
    graphic = Graphic.new(input)
    if graphic.save
      Success(graphic)
    else
      Failure(message: graphic.errors.to_h)
    end
  end
end
