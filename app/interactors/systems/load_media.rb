# frozen_string_literal: true

class Systems::LoadMedia
  include Dry::Monads[:result, :do]

  SYSTEM_SCHEMA = Dry::Schema.Params do
    required(:id).filled(:integer)
    required(:name).filled(:string)
    required(:file_name).filled(:string)
    required(:io_file).filled(:string)
  end

  def call(input)
    params = yield validate(input)
    system = yield fetch_system(params)
    load(system, params)
  end

  private

  def validate(input)
    result = SYSTEM_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def fetch_system(params)
    system = System.find_by(id: params[:id])
    if system
      Success(system)
    else
      Failure(message: 'system not found')
    end
  end

  def load(system, params)
    key = "#{system.key}_#{params[:name]}"
    media = Medium.find_or_initialize_by(key: key)
    media.image.attach(io: StringIO.new(params[:io_file]), filename: params[:file_name])
    if media.save
      Success(key: key)
    else
      Failure(message: media.errors.to_h, status: 422)
    end
  end
end
