# frozen_string_literal: true

class UsersController < ApplicationController
  def current
    render json: ShortUserSerializer.new(current_user)
  end
end
