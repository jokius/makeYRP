# frozen_string_literal: true

class Graphics::Update
  include Dry::Monads[:result, :do]

  GRAPHIC_UPDATE_SCHEMA = Dry::Schema.Params do
    required(:id).filled(:integer)
    required(:layer).filled(:string)
    required(:params).filled(:hash)
  end

  def call(input)
    params = yield validate(input)
    hash = yield fetch_graphic(params)
    update(hash)
  end

  private

  def validate(input)
    result = GRAPHIC_UPDATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h)
    end
  end

  def fetch_graphic(input)
    graphic = Graphic.find_by(id: input.delete(:id))
    if graphic
      Success(graphic: graphic, input: input)
    else
      Failure(message: 'graphic not found')
    end
  end

  def update(graphic:, input:)
    graphic.assign_attributes(input)
    if graphic.save
      Success(graphic)
    else
      Failure(message: graphic.errors.to_h)
    end
  end
end
