#!/bin/bash

echo "==> Getting Host Keys for github.com and bitbucket.org"
ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts
ssh-keyscan -t rsa bitbucket.org >> /root/.ssh/known_hosts

echo "==> Setting COMPOSER_HOME /root/.composer"
export COMPOSER_HOME=/root/.composer

if [ "$GITHUB_TOKEN" ]; then
    echo "==> Setting GitHub Access Token"
    composer config -g github-oauth.github.com $GITHUB_TOKEN
fi

if [ "$TORAN_HOST" ]; then
    echo "==> Adding auth for $TORAN_HOST";
    composer config -g http-basic.$TORAN_HOST $TORAN_HTTP_USER $TORAN_HTTP_PASS
fi

if [ "$ID_RSA" ]; then
    echo "==> Found id_rsa, pulling..."
    wget "$ID_RSA" -O /root/.ssh/id_rsa
    chmod 600 /root/.ssh/id_rsa
fi

if [ "$GIT_URL" ]; then
    if [ "$PRE_INSTALL" ]; then
        echo "==> Running PRE_INSTALL"
        sh -c "$PRE_INSTALL"
    fi

    echo "==> Found git URL: $GIT_URL"
    echo "==> Cleaning /var/www"
    rm -rf /var/www/*
    echo "==> Cloning Application into /var/www"
    git clone $GIT_URL /var/www

    if [ "$COMPOSER_INSTALL" != "0" ]; then
        echo "==> Clearing Composer Cache due to conflicts with the hirak/prestissimo package. See https://github.com/hirak/prestissimo/issues/45"
        composer clear-cache
        echo "==> Running 'composer install --no-dev'"
        composer install --no-dev
    fi

    if [ "$STORAGE_WRITABLE" != "0" ]; then
        echo "==> Attempting to make storage directory writable"
        chown -R www-data:www-data /var/www/storage
    fi

    if [ "$SCHEDULE_ARTISAN_RUN" != "0" ]; then
        echo "==> Scheduling cron job for artisan schedule:run"
        crontab /root/crontab.txt
        crontab -l
    fi

    if [ "$POST_INSTALL" ]; then
        echo "==> Running POST_INSTALL"
        sh -c "$POST_INSTALL"
    fi
fi
