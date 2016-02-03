#!/bin/bash

echo "==> Setting COMPOSER_HOME /root/.composer"
export COMPOSER_HOME=/root/.composer

if [ $GITHUB_TOKEN ]; then
    echo "==> Setting GitHub Access Token"
    composer config -g github-oauth.github.com $GITHUB_TOKEN
fi

if [ $GIT_URL ]; then
  echo "==> Found git URL: $GIT_URL"
  echo "==> Cleaning /var/www"
  rm -rf /var/www/* /var/www/.*
  echo "==> Cloning Application into /var/www"
  git clone $GIT_URL /var/www

  if [ "$COMPOSER_INSTALL" != "0" ]; then
    echo "==> Running 'composer install --no-dev'"
    composer install --no-dev
  fi

  if [ "$STORAGE_WRITABLE" != "0" ]; then
      echo "==> Attempting to make storage directory writable"
      chmod -R 777 storage
  fi

fi
