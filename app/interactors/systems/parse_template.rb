# frozen_string_literal: true

class Systems::ParseTemplate
  include Dry::Transaction
  SYSTEM_SCHEMA = Dry::Schema.Params do
    required(:name).filled(:string)
    required(:file).filled(:any)
    required(:data_file).filled(:any)
    required(:private_data_file).maybe(:any)
  end

  step :validate
  map :parse

  def validate(input)
    result = SYSTEM_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def parse(input)
    private_data = parse_private_data(input[:private_data_file])
    data = parse_data(input[:data_file])
    template = open_template(input[:file])
    template.scan(/("\$(\w*)")/).each do |matchers|
      reg, key = matchers
      text = (private_data[key] || data[key] || key).to_json
      new_temp = template.sub(reg, text)

      template = new_temp
    end

    { name: input[:name], template: JSON.parse(template, symbolize_names: true) }
  end

  private

  def open_template(template_file)
    file = template_file.read
    file.force_encoding 'UTF-8'
  end

  def parse_private_data(private_data_file)
    return {} if private_data_file.nil? || private_data_file == 'null'

    file = private_data_file.read
    file.force_encoding 'UTF-8'
    JSON.parse(file)
  end

  def parse_data(data_file)
    file = data_file.read
    file.force_encoding 'UTF-8'
    JSON.parse(file)
  end
end
