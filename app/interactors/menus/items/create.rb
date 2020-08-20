# frozen_string_literal: true

class Menus::Items::Create
  include Dry::Monads[:result, :do]

  ITEMS_CREATE_SCHEMA = Dry::Schema.Params do
    required(:owner_id).filled(:integer)
    required(:menu_id).filled(:integer)
    required(:params).filled(:hash)
  end

  def call(input)
    params = yield validate(input)
    hash = yield fetch_menu(params)
    create(hash)
  end

  private

  def validate(input)
    result = ITEMS_CREATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def fetch_menu(input)
    menu = Menu.find(input[:menu_id])
    if menu
      Success(menu: menu, input: input)
    else
      Failure(message: 'menu not found', status: :not_fount)
    end
  end

  def create(menu:, input:)
    item = menu.items.build(params: input[:params], owner_id: input[:owner_id])

    if item.save
      Success(item)
    else
      Failure(message: item.errors.to_h, status: 422)
    end
  end
end
