# frozen_string_literal: true

class Folders::Update
  include Dry::Monads[:result, :do]

  FOLDERS_UPDATE_SCHEMA = Dry::Schema.Params do
    required(:id).filled(:integer)
    required(:name).filled(:string)
  end

  def call(input)
    params = yield validate(input)
    folder = yield fetch_folder(params)
    update(folder: folder, input: params)
  end

  private

  def validate(input)
    result = FOLDERS_UPDATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def fetch_folder(input)
    folder = Folder.find_by(id: input.delete(:id))
    if folder
      Success(folder)
    else
      Failure(message: 'folder not found', status: :not_fount)
    end
  end

  def update(folder:, input:)
    if folder.update(input)
      Success(folder)
    else
      Failure(message: folder.errors.to_h, status: 422)
    end
  end
end
