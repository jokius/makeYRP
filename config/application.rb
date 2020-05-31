# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)

module MakeYRP
  class Application < Rails::Application
    config.load_defaults 6.0
    config.i18n.default_locale = :ru

    config.generators do |generator|
      generator.test_framework :rspec
      generator.assets false
      generator.helper false
    end
  end
end
