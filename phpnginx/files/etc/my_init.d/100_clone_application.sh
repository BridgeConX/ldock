#!/bin/bash

echo "==> Setting COMPOSER_HOME /root/.composer"
export COMPOSER_HOME=/root/.composer

if [ "$GITHUB_TOKEN" ]; then
    echo "==> Setting GitHub Access Token"
    composer config -g github-oauth.github.com $GITHUB_TOKEN
fi

if [ "$ID_RSA" ]; then
    echo "==> Found id_rsa, writing..."
    echo "$ID_RSA" >> /root/.ssh/id_rsa
    chmod 600 /root/.ssh/id_rsa
fi

if [ "$GIT_URL" ]; then
    if [ "$PRE_INSTALL" ]; then
        echo "==> Running PRE_INSTALL"
        sh -c "$PRE_INSTALL"
    fi

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

    if [ "$POST_INSTALL" ]; then
        echo "==> Running POST_INSTALL"
        sh -c "$POST_INSTALL"
    fi

fi
