#!/usr/bin/env sh

set -e
cmd="$@"

# update html configuration
ROOT_DIR=/var/www/html
for file in $ROOT_DIR/static/js/*.js* $ROOT_DIR/index.html;
do
  sed -i "s|API_BASE_URL_PLACEHOLDER|$API_BASE_URL|g" $file
done

# start application
>&2 echo "Starting process: $cmd"
exec $cmd
