# frozen_string_literal: true

class Pages::Update
  include Dry::Transaction
  PAGES_UPDATE_SCHEMA = Dry::Schema.Params do
    required(:id).filled(:integer)
    required(:name).filled(:string)
    required(:page_params).filled(:hash)
  end

  step :validate
  step :update

  def validate(input)
    result = PAGES_UPDATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def update(input)
    page = Page.find(input[:id])
    page.name = input[:name]
    page.params = input[:page_params]

    if page.save
      Success(page)
    else
      Failure(message: page.errors.to_h, status: 422)
    end
  end
end
