# frozen_string_literal: true

class AclsController < ApplicationController
  def show
    render json: object.game.users.map { |user| AclSerializer.new(object, user: user) }
  end

  def object
    case params[:type]
    when 'sheet'
      Sheet.find(params[:id])
    end
  end
end
