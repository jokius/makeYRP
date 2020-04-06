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

set :puma_bind, %w[
  tcp://0.0.0.0:9292
  unix:///tmp/puma.sock
  http://0.0.0.0:3000
]

before 'puma:smart_restart', 'deploy:load_assets'
namespace :deploy do
  desc 'load assets'
  task :load_assets do
    sh 'sh load_assets_prod.sh'
  end
end
