# frozen_string_literal: true

class Folders::Create
  include Dry::Transaction
  FOLDERS_CREATE_SCHEMA = Dry::Schema.Params do
    required(:user_id).filled(:integer)
    required(:name).filled(:string)
    required(:parent_id).maybe(:integer)
  end

  step :validate
  step :create

  def validate(input)
    result = FOLDERS_CREATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def create(input)
    user = user_by_id(input[:user_id])
    input[:parent_id] ||= user.folders.root.id
    folder = Folder.new(input)
    if folder.save
      Success(folder)
    else
      Failure(message: folder.errors.to_h, status: 422)
    end
  end

  def user_by_id(id)
    User.find(id)
  end
end
