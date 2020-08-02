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
    load(yield validate(input))
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

  def load(input)
    key = "system_#{input[:id]}_#{input[:name]}"
    media = Medium.find_or_initialize_by(key: key)
    media.image.attach(io: StringIO.new(input[:io_file]), filename: input[:file_name])
    if media.save
      Success(key: key)
    else
      Failure(message: media.errors.to_h, status: 422)
    end
  end
end
