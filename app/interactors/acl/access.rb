# frozen_string_literal: true

class Acl::Access
  include Dry::Monads[:result, :do]

  ACCESS_SCHEMA = Dry::Schema.Params do
    required(:type).filled(:string)
    required(:id).filled(:integer)
    required(:read_all).filled(:bool)
    optional(:write_all).filled(:bool)
    optional(:levels).each do
      hash do
        required(:user_id).filled(:string)
        required(:read).filled(:bool)
        required(:write).filled(:bool)
      end
    end
  end

  def call(input)
    ActiveRecord::Base.transaction do
      params = yield validate(input)
      record = yield fetch_record(params)
      save_access(record, params)
    end
  end

  private

  def validate(input)
    result = ACCESS_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h)
    end
  end

  def fetch_record(input)
    record = case input.delete(:type)
             when 'sheet'
               Sheet.find_by(id: input.delete(:id))
             when 'menu_item'
               Menus::Item.find_by(id: input.delete(:id))
             end

    if record
      Success(record)
    else
      Failure(message: 'record not found')
    end
  end

  def save_access(record, params)
    yield save_access_levels(record, params.delete(:levels))
    record.assign_attributes(params)
    if record.save
      Success(record)
    else
      Failure(message: record.errors.to_h)
    end
  end

  def save_access_levels(record, levels)
    return Success() if levels.nil?

    levels.each do |item|
      item[:user_id]
      acl = record.access_levels.find_or_initialize_by(user_id: item[:user_id])
      acl.read = item[:read]
      acl.write = item[:write]

      return Failure(message: acl.errors.to_h) unless acl.save
    end

    Success()
  end
end
