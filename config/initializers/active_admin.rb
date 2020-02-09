# frozen_string_literal: true

ActiveAdmin.setup do |config|
  config.site_title = 'Make Yrp'
  config.authorization_adapter = ActiveAdminAdapter
  config.on_unauthorized_access = :access_denied
  config.authentication_method = :authenticate_user!
  config.current_user_method = :current_user
  config.logout_link_path = :destroy_admin_user_session_path
  config.batch_actions = true
  config.filter_attributes = %i[encrypted_password password password_confirmation]
  config.localize_format = :long
  config.comments_menu = false
end
