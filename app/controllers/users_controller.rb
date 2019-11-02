# frozen_string_literal: true

class UsersController < ApplicationController
  def current
    respond_json json: current_user, serializer: ShortUserSerializer
  end
end
