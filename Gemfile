# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'sassc-rails', '>= 2.1.2'

gem 'rails', '~> 6.0.3', '>= 6.0.3.1'

gem 'puma', '~> 4.3'

gem 'bootsnap', '>= 1.4.2', require: false

gem 'listen', '>= 3.0.5'

# JSON API
gem 'fast_jsonapi'

# Database
gem 'awesome_nested_set', '>= 3.2.0'
gem 'pg'

# Auth
gem 'devise', '>= 4.7.1'
gem 'devise-jwt'
gem 'warden-jwt_auth', '~> 0.4.2'

gem 'russian'

# Dry
gem 'dry-monads'
gem 'dry-schema'

gem 'ffaker'
gem 'image_processing'
gem 'mini_magick'

gem 'tzinfo-data'

# Websocket
gem 'anycable-rails'
gem 'daemons', '~> 1.3', require: false
gem 'redis'

# ACL
gem 'action_policy'

# media
gem 'active_storage-send_zip'
gem 'rubyzip'

# Clone
gem 'clowne'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails', '>= 5.1.1'
end

group :development do
  gem 'annotate'
  gem 'brakeman'
  gem 'capistrano', '~> 3.12', require: false
  gem 'capistrano3-puma', '>= 4.0.0', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rbenv', require: false
  gem 'foreman'
  gem 'meta_request', '>= 0.7.2'
  gem 'reek', require: false
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rspec', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'sshkit-sudo'
  gem 'web-console', '>= 4.0.1'
end

group :test do
  gem 'action-cable-testing', '>= 0.6.1'
  gem 'database_cleaner'
  gem 'fasterer'
  gem 'json_matchers'
  gem 'mock_redis'
  gem 'rspec-mocks'
  gem 'rspec-rails', '>= 4.0.0'
end
