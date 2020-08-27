# frozen_string_literal: true

class Menus::Folders::Create
  include Dry::Monads[:result, :do]

  FOLDER_CREATE_SCHEMA = Dry::Schema.Params do
    required(:owner_id).filled(:integer)
    required(:parent_id).filled(:integer)
    required(:name).filled(:string)
  end

  def call(input)
    params = yield validate(input)
    parent = yield fetch_parent(input)
    create(parent: parent, params: params)
  end

  private

  def validate(input)
    result = FOLDER_CREATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def fetch_parent(input)
    folder = Menus::ItemFolder.find(input[:parent_id])
    if folder
      Success(folder)
    else
      Failure(message: 'folder not found', status: :not_fount)
    end
  end

  def create(parent:, params:)
    folder = parent.children.build(params.merge(menu_id: parent.menu_id))

    if folder.save
      Success(folder.folder_struct(items: [], children: [], path_loaded: true))
    else
      Failure(message: folder.errors.to_h, status: 422)
    end
  end
end
