# frozen_string_literal: true

class Images::Update
  include Dry::Monads[:result, :do]

  IMAGE_UPDATE_SCHEMA = Dry::Schema.Params do
    required(:id).filled(:integer)
    required(:params).filled(:hash)
    required(:layer).filled(:string)
  end

  def call(input)
    params = yield validate(input)
    image = yield fetch_image(params)
    update(image: image, input: params)
  end

  private

  def validate(input)
    result = IMAGE_UPDATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(result.errors.to_h)
    end
  end

  def fetch_image(input)
    image = Image.find_by(id: input.delete(:id))
    if image
      Success(image)
    else
      Failure('image not found')
    end
  end

  def update(image:, input:)
    image.assign_attributes(input)
    if image.save
      Success(image)
    else
      Failure(image.errors.to_h)
    end
  end
end
