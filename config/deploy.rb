# frozen_string_literal: true

set :rbenv_type, :user
set :rbenv_ruby, '2.7.1'
set :application, 'make_yrp'
set :repo_url, 'git@github.com:jokius/makeYRP.git'

ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :deploy_to, '/home/deploy/app/backend'

append :linked_dirs,
       'tmp/pids',
       'tmp/cache',
       'tmp/sockets',
       'log',
       'storage'

append :linked_files,
       'config/database.yml',
       'config/storage.yml',
       'config/master.key',
       'config/credentials.yml.enc'
