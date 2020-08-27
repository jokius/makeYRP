# frozen_string_literal: true

class Menus::Items::Update
  include Dry::Monads[:result, :do]

  ITEMS_UPDATE_SCHEMA = Dry::Schema.Params do
    required(:id).filled(:integer)
    required(:params).filled(:hash)
  end

  def call(input)
    params = yield validate(input)
    menu_item = yield fetch_menu_item(params)
    update(menu_item: menu_item, input: params)
  end

  private

  def validate(input)
    result = ITEMS_UPDATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def fetch_menu_item(input)
    menu_item = ::Menus::Item.find_by(id: input.delete(:id))
    if menu_item
      Success(menu_item)
    else
      Failure(message: 'menu item not found')
    end
  end

  def update(menu_item:, input:)
    if menu_item.update(input)
      Success(menu_item)
    else
      Failure(message: menu_item.errors.to_h)
    end
  end
end
