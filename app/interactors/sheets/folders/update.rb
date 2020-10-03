# frozen_string_literal: true

class Sheets::Folders::Update
  include Dry::Monads[:result, :do]

  FOLDER_UPDATE_SCHEMA = Dry::Schema.Params do
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
    result = FOLDER_UPDATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def fetch_folder(input)
    folder = ::Games::SheetFolder.find_by(id: input.delete(:id))
    if folder
      Success(folder)
    else
      Failure(message: 'folder not found')
    end
  end

  def update(folder:, input:)
    if folder.update(input)
      Success(folder.folder_struct(sheets: folder.sheets, children: folder.children, path_loaded: true))
    else
      Failure(message: folder.errors.to_h)
    end
  end
end
