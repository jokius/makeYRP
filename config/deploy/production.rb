# frozen_string_literal: true

Dotenv.load

server ENV['HOSTNAME'],
       user: ENV['USERNAME'],
       roles: %w[app db web]

set :default_env, {
  RAILS_ENV: 'production',
  ACTION_CABLE_ALLOWED_HOSTS: ENV['ACTION_CABLE_ALLOWED_HOSTS']
}
