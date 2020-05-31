# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      verified_user = User.find_by(jti: jwt['jti'])
      verified_user || reject_unauthorized_connection
    end

    def jwt
      token = request.params[:token].split(' ')[1]
      JWT.decode(token, Rails.application.credentials.jwt_secret, true, algorithm: 'HS256', verify_jti: true)[0]
    end
  end
end
