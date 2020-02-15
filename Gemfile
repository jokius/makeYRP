# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'sassc-rails'

gem 'rails', '~> 6.0.0'

gem 'puma', '~> 3.12'

gem 'webpacker', '~> 4.0'

gem 'bootsnap', '>= 1.4.2', require: false

# JSON API
gem 'active_model_serializers', '~> 0.10.0'

# Database
gem 'awesome_nested_set'
gem 'pg'

# Auth
gem 'devise'

gem 'russian'

# Dry
gem 'dry-monads'
gem 'dry-schema'

gem 'ffaker'
gem 'image_processing'
gem 'mini_magick'

gem 'tzinfo-data'

gem 'redis'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
end

group :development do
  gem 'annotate', git: 'https://github.com/ctran/annotate_models.git'
  gem 'brakeman'
  gem 'foreman'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'meta_request'
  gem 'reek', require: false
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rspec', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'action-cable-testing'
  gem 'database_cleaner'
  gem 'fasterer', '~> 0.7.1'
  gem 'json_matchers'
  gem 'mock_redis'
  gem 'rspec-mocks'
  gem 'rspec-rails'
end
