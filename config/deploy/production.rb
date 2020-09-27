# frozen_string_literal: true

Dotenv.load

server ENV['HOSTNAME'],
       user: ENV['USERNAME'],
       roles: %w[app db web]

set :default_env, {
  RAILS_ENV: 'production',
  CABLE_URL: ENV['CABLE_URL']
}
