# frozen_string_literal: true

class AclsController < ApplicationController
  def show
    item = object
    render json: item, serializer: UsersAclSerializer, users: item.game.users
  end

  def object
    case params[:type]
    when 'sheet'
      Sheet.find(params[:id])
    end
  end
end
