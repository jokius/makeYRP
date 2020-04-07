# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.12.1'

set :rbenv_type, :user
set :rbenv_ruby, '2.7.1'
set :application, 'make_yrp'
set :repo_url, 'git@github.com:jokius/makeYRP.git'

ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :deploy_to, '/home/deploy/app'

append :linked_dirs,
       'tmp/pids',
       'tmp/cache',
       'tmp/sockets',
       'vendor/bundle',
       'public/packs',
       'public/assets',
       'public/storage',
       '.bundle',
       'log',
       'node_modules'

append :linked_files,
       'config/database.yml',
       'config/storage.yml',
       'config/master.key',
       'config/credentials.yml.enc'
