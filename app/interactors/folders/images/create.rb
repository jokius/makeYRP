# frozen_string_literal: true

class Folders::Images::Create
  include Dry::Transaction

  IMAGES_CREATE_SCHEMA = Dry::Schema.Params do
    required(:folder_id).filled(:integer)
    required(:file).maybe(:any)
  end

  step :validate
  step :get_folder
  step :create

  def validate(input)
    result = IMAGES_CREATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def get_folder(input)
    folder = Folder.find_by(id: input[:folder_id])
    if folder
      Success(folder: folder, file: input[:file])
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
