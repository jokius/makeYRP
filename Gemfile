# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# JSON API
gem 'fast_jsonapi'

# Database
gem 'bson_ext'
gem 'mongoid', git: 'https://github.com/mongodb/mongoid.git'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'overcommit'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'reek', require: false
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rspec', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'database_cleaner'
  gem 'fasterer', '~> 0.7.1'
  gem 'mock_redis'
  gem 'pronto', '~> 0.10.0'
  gem 'pronto-brakeman', '~> 0.10.0', require: false
  gem 'pronto-fasterer', '~> 0.10.0', require: false
  gem 'pronto-haml', '~> 0.10.0', require: false
  gem 'pronto-rails_best_practices', '~> 0.10.0', require: false
  gem 'pronto-rails_schema', '~> 0.10.0', require: false
  gem 'pronto-reek', '~> 0.10.0', require: false
  gem 'pronto-rubocop', '~> 0.10.0', require: false
  gem 'rspec-mocks'
  gem 'rspec-rails'
end
