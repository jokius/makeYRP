# frozen_string_literal: true

class Folders::Update
  include Dry::Transaction
  FOLDERS_UPDATE_SCHEMA = Dry::Schema.Params do
    required(:id).filled(:integer)
    required(:name).filled(:string)
  end

  step :validate
  step :update

  def validate(input)
    result = FOLDERS_UPDATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def update(input)
    folder = Folder.find_by(id: input.delete(:id))
    return Failure(message: 'folder not found', status: :not_fount) unless folder

    if folder.update(input)
      Success(folder)
    else
      Failure(message: folder.errors.to_h, status: 422)
    end
  end
end
