# frozen_string_literal: true

class AclsController < ApplicationController
  def show
    item = object
    if item
      render json: item, serializer: UsersAclSerializer, users: item.game.users
    else
      render json: 'incorrect type', status: :unprocessable_entity
    end
  end

  def object
    case params[:type]
    when 'sheet'
      Sheet.find(params[:id])
    when 'menu_item'
      Menus::Item.find(params[:id])
    else
      false
    end
  end
end
