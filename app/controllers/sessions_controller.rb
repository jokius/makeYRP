# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  def create
    super do
      return render(json: { token: request.env['warden-jwt_auth.token'] })
    end
  end
end
