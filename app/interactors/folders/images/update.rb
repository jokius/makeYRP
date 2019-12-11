# frozen_string_literal: true

class Folders::Images::Update
  include Dry::Transaction
  IMAGES_UPDATE_SCHEMA = Dry::Schema.Params do
    required(:id).filled(:integer)
    required(:name).filled(:string)
  end

  step :validate
  step :update

  def validate(input)
    result = IMAGES_UPDATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def update(input)
    image = FolderFile.find_by(id: input.delete(:id))
    return Failure(message: 'image not found', status: :not_fount) unless image

    if image.update(input)
      Success(image)
    else
      Failure(message: image.errors.to_h, status: 422)
    end
  end
end
