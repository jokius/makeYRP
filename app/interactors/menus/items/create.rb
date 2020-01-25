# frozen_string_literal: true

class Menus::Items::Create
  include Dry::Transaction

  ITEMS_CREATE_SCHEMA = Dry::Schema.Params do
    required(:type).filled(:string)
    required(:game_id).filled(:integer)
    required(:params).filled(:hash)
  end

  step :validate
  map :fetch_menu
  step :create

  def validate(input)
    result = ITEMS_CREATE_SCHEMA.call(input)
    if result.success?
      Success(result.to_h)
    else
      Failure(message: result.errors.to_h, status: 422)
    end
  end

  def fetch_menu(input)
    menu = Menu.find_by(game_id: input[:game_id], identifier: input[:type])
    { menu: menu, params: input[:params] }
  end

  def create(menu:, params:)
    item = menu.items.build(params: params)

    if item.save
      Success(item)
    else
      Failure(message: item.errors.to_h, status: 422)
    end
  end
end
