# frozen_string_literal: true

class UsersController < ApplicationController
  def current
    render json: ShortUserSerializer.new(current_user)
  end

  def update
    responds(Users::Update, params.merge(id: current_user.id)) do
      render json: ShortUserSerializer.new(current_user)
    end
  end
end
