# frozen_string_literal: true

class Admin::ApplicationController < ::ApplicationController
  before_action :authenticate_admin!

  private

  def authenticate_admin!
    return if current_user.admin?

    redirect_to '/'
  end
end
