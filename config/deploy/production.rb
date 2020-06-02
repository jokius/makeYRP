# frozen_string_literal: true

server 'makeyrp.ru',
       user: 'deploy',
       roles: %w[app db web]

set :default_env, {
  RAILS_ENV: 'production',
  ACTION_CABLE_ALLOWED_HOSTS: 'http://localhost:3000,'\
                              'http://makeyrp.ru,'\
                              'https://makeyrp.ru'
}
