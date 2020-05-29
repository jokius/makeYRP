#!/usr/bin/env sh

app() {
  rm -rf public/assets/
  rm -rf public/public/
  bundle
  bundle exec rails credentials:edit
  bundle exec rails assets:precompile
  bundle exec rails db:prepare
  bundle exec rails s -b 0.0.0.0 "$@"
}

rake() {
  bundle exec rails "$@"
}

rails() {
  bundle exec rails "$@"
}

case $1 in
  app) shift && app $@;;
  rake) shift && rake $@;;
  rails) shift && rails $@;;
  *) echo "Cannot find command" && exit 1;;
esac
