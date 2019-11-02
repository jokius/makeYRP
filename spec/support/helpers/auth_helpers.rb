# frozen_string_literal: true

module AuthHelpers
  def sign_in_user(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user, scope: :user
  end
end
