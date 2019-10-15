# frozen_string_literal: true

class RegistrationsController < ::Devise::RegistrationsController
  clear_respond_to
  respond_to :json

  def new; end

  private

  def sign_up_params
    params.require(:user).permit(:nickname, :email, :password)
  end
end
