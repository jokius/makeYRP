# frozen_string_literal: true

class Folders::Images::Create
  include Dry::Monads[:result, :do]

  IMAGES_CREATE_SCHEMA = Dry::Schema.Params do
    required(:folder_id).filled(:integer)
    required(:file).maybe(:any)
  end

  def call(input)
    params = yield validate(input)
    folder = yield fetch_folder(params)
    create(folder: folder, file: input[:file])
  end

  private

  def validate(input)
    result = IMAGES_CREATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def fetch_folder(input)
    folder = Folder.find_by(id: input[:folder_id])
    if folder
      Success(folder)
    else
      Failure(message: 'folder not found', status: :not_fount)
    end
  end

  def create(folder:, file:)
    name = file.original_filename
    record = folder.files.build(name: name, image: { io: file.open, filename: name })

    if record.save
      Success(folder)
    else
      Failure(message: folder.errors.to_h, status: 422)
    end
  end
end
