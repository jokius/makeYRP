# frozen_string_literal: true

require 'zip'

class Systems::LoadMedias
  include Dry::Monads[:result, :do]

  SYSTEM_SCHEMA = Dry::Schema.Params do
    required(:id).filled(:integer)
    required(:media_file).maybe(:any)
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
    return if input[:media_file].blank? || input[:media_file] == 'null'

    ::Zip::File.open_buffer(input[:media_file].read) do |zip_file|
      zip_file.each { |entry| save_media(id: input[:id], entry: entry) if correct?(entry) }
    end

    Success()
  end

  def correct?(entry)
    entry.name[0] != '_' && /\.(gif|jpe?g|tiff?|png|webp|bmp)$/i.match?(entry.name)
  end

  def save_media(id:, entry:)
    parts = entry.name.split('.')
    return if parts.size > 2

    Systems::LoadMedia.new.call(id: id, name: parts[0], file_name: entry.name,
                                io_file: entry.get_input_stream.read)
  end
end
