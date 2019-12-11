#!/usr/bin/env sh

function app {
  bundle
  bundle exec rails credentials:edit
  bundle exec rails assets:precompile
  bundle exec rails db:prepare
  rm -rf node_modules
  bundle exec rails s -b 0.0.0.0 "$@"
}

function rake {
  bundle exec rails "$@"
}

function rails {
  bundle exec rails "$@"
}

case $1 in
  app) shift && app $@;;
  rake) shift && rake $@;;
  rails) shift && rails $@;;
  *) echo "Cannot find command" && exit 1;;
esac
