# frozen_string_literal: true

class Menus::Items::Create
  include Dry::Monads[:result, :do]

  ITEMS_CREATE_SCHEMA = Dry::Schema.Params do
    required(:owner_id).filled(:integer)
    required(:folder_id).filled(:integer)
    required(:params).filled(:hash)
  end

  def call(input)
    params = yield validate(input)
    folder = yield fetch_folder(params)
    create(folder: folder, input: params)
  end

  private

  def validate(input)
    result = ITEMS_CREATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def fetch_folder(input)
    folder = Menus::ItemFolder.find(input[:folder_id])
    if folder
      Success(folder)
    else
      Failure(message: 'folder not found', status: :not_fount)
    end
  end

  def create(folder:, input:)
    item = folder.items.build(params: input[:params], owner_id: input[:owner_id], menu_id: folder.menu_id)

    if item.save
      Success(item)
    else
      Failure(message: item.errors.to_h, status: 422)
    end
  end
end
