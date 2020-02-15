# frozen_string_literal: true

class Folders::Images::Update
  include Dry::Monads[:result, :do]

  IMAGES_UPDATE_SCHEMA = Dry::Schema.Params do
    required(:id).filled(:integer)
    required(:name).filled(:string)
  end

  def call(input)
    params = yield validate(input)
    hash = yield fetch_image(params)
    update(hash)
  end

  private

  def validate(input)
    result = IMAGES_UPDATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def fetch_image(input)
    image = FolderFile.find_by(id: input.delete(:id))
    if image
      Success(image: image, input: input)
    else
      Failure(message: 'image not found', status: :not_fount)
    end
  end

  def update(image:, input:)
    if image.update(input)
      Success(image)
    else
      Failure(message: image.errors.to_h, status: 422)
    end
  end
end
