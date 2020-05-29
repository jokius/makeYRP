# frozen_string_literal: true

class Pages::Update
  include Dry::Monads[:result, :do]

  PAGES_UPDATE_SCHEMA = Dry::Schema.Params do
    required(:id).filled(:integer)
    required(:name).filled(:string)
    required(:page_params).filled(:hash)
  end

  def call(input)
    params = yield validate(input)
    hash = yield fetch_page(params)
    update(hash)
  end

  private

  def validate(input)
    result = PAGES_UPDATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h)
    end
  end

  def fetch_page(input)
    page = Page.find_by(id: input.delete(:id))
    if page
      Success(page: page, input: input)
    else
      Failure(message: 'page not found')
    end
  end

  def update(page:, input:)
    page.name = input[:name]
    page.params = input[:page_params]

    if page.save
      Success(page)
    else
      Failure(message: page.errors.to_h)
    end
  end
end
