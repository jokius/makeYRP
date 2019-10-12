#!/usr/bin/env sh

function app {
    ./bin/rails s -b 0.0.0.0 "$@"
}

function rake {
    bundle exec rails "$@"
}

case $1 in
    app) shift && app $@;;
    rake) shift && rake $@;;
    *) echo "Cannot find command" && exit 1;;
esac
