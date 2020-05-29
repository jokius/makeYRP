# frozen_string_literal: true

class RegistrationsController < ::Devise::RegistrationsController
  def create
    super do
      # @self.resource = warden.authenticate!(auth_options)
      return render(json: { token: request.env['warden-jwt_auth.token'] })
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:nickname, :email, :password)
  end
end
