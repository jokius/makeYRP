# frozen_string_literal: true

class Folders::Images::Drop
  include Dry::Monads[:result, :do]

  IMAGES_DROP_SCHEMA = Dry::Schema.Params do
    required(:user_id).filled(:integer)
    required(:page_id).filled(:integer)
    required(:rank).filled(:integer)
    required(:layer).filled(:string)
    required(:x).filled(:float)
    required(:y).filled(:float)
    required(:file).maybe(:any)
  end

  def call(input)
    params = yield validate(input)
    user = yield fetch_user(params)
    image = yield create(user: user, file: input[:file])
    save_image_in_page(input: params, file: image)
  end

  private

  def validate(input)
    result = IMAGES_DROP_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def fetch_user(input)
    user = User.find_by(id: input[:user_id])
    if user
      Success(user)
    else
      Failure(message: 'user not found', status: :not_fount)
    end
  end

  def create(user:, file:)
    name = file.original_filename
    record = user.folders.root.files.build(name: name, image: { io: file.open, filename: name })

    if record.save
      Success(record)
    else
      Failure(message: record.errors.to_h, status: 422)
    end
  end

  def save_image_in_page(input:, file:)
    meta = ActiveStorage::Analyzer::ImageAnalyzer.new(file.image).metadata
    params = {
      url: file.image_url,
      scaleX: 1,
      scaleY: 1,
      x: input[:x],
      y: input[:y],
      width: meta[:width],
      height: meta[:height],
      rank: input[:rank]
    }

    Images::Create.new.call({ owner_id: input[:user_id], page_id: input[:page_id],
                              layer: input[:layer], params: params })
  end
end
