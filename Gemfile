# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'rails', '~> 6.0.0'

gem 'puma', '~> 3.11'

gem 'webpacker', '~> 4.0'

gem 'bootsnap', '>= 1.4.2', require: false

# JSON API
gem 'fast_jsonapi'

# Database
gem 'bson_ext'
gem 'mongoid', git: 'https://github.com/mongodb/mongoid.git'

# Auth
gem 'devise'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'foreman'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'overcommit'
  gem 'reek', require: false
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rspec', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
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
